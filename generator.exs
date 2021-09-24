#!/usr/bin/env elixir

defmodule Generator do
	require EEx
	EEx.function_from_file :defp, :dockerfile2, "Dockerfile.eex", [:baseimage, :variables, :repos, :packages]
	EEx.function_from_file :defp, :workflow2, ".github/workflows/dockerimage.eex", [:jobs]

	defp repo({:gcc, _gcc_version}, {:opensuse, :tumbleweed}) do
		"https://download.opensuse.org/repositories/devel:/gcc/openSUSE_Factory/devel:gcc.repo"
	end
	defp repo({:gcc, _gcc_version}, {:opensuse, opensuse_version}) do
		"https://download.opensuse.org/repositories/devel:/gcc/openSUSE_Leap_#{opensuse_version}/devel:gcc.repo"
	end
	defp repo({:clang, _clang_version}, {:opensuse, :tumbleweed}) do
		"https://download.opensuse.org/repositories/devel:/tools:/compiler/openSUSE_Factory/devel:tools:compiler.repo"
	end
	defp repo({:clang, _clang_version}, {:opensuse, opensuse_version}) do
		"https://download.opensuse.org/repositories/devel:/tools:/compiler/openSUSE_Leap_#{opensuse_version}/devel:tools:compiler.repo"
	end
	defp repo({:qt, {qt_major, qt_minor}}, {:opensuse, :tumbleweed}) do
		"https://download.opensuse.org/repositories/KDE:/Qt:/#{qt_major}.#{qt_minor}/openSUSE_Tumbleweed/KDE:Qt:#{qt_major}.#{qt_minor}.repo"
	end
	defp repo({:qt, {qt_major, qt_minor}}, {:opensuse, opensuse_version}) do
		"https://download.opensuse.org/repositories/KDE:/Qt:/#{qt_major}.#{qt_minor}/openSUSE_Leap_#{opensuse_version}/KDE:Qt:#{qt_major}.#{qt_minor}.repo"
	end

	defp package({:gcc, gcc_version}) do
		"gcc#{gcc_version}-c++"
	end
	defp package({:clang, clang_version}) do
		"clang#{clang_version}"
	end
	defp package({:qt, {5, _qt_minor}}) do
		"libQt5Widgets-devel libQt5Test-devel libQt5Gui-devel libQt5Core-devel"
	end
	defp package({:qt, {6, _qt_minor}}) do
		"qt6-widgets-devel qt6-test-devel qt6-gui-devel qt6-core-devel qt6-openglwidgets-devel qt6-opengl-devel qt6-base-devel"
	end

	defp variables({:gcc, gcc_version}) do
		[cc: "gcc-#{gcc_version}", cxx: "g++-#{gcc_version}"]
	end
	defp variables({:clang, _clang_version}) do
		[cc: "clang", cxx: "clang++"]
	end

	defp baseimage({:opensuse, :tumbleweed}) do
		"opensuse/tumbleweed"
	end
	defp baseimage({:opensuse, opensuse_version}) do
		"opensuse/leap:#{opensuse_version}"
	end

	def path(%{:compiler => {comp, comp_version}, :qt => {qt_major, qt_minor}}) do
		"#{comp}#{comp_version}/qt#{qt_major}#{qt_minor}"
	end

	def dockerfile(%{:compiler => comp, :qt => qt}, distro) do
		baseimage = baseimage(distro)
		repos = [repo(comp, distro), repo({:qt, qt}, distro)]
		variables = variables(comp)
		packages = [package(comp), package({:qt, qt}), "cmake", "make", "git", "tar"]
		dockerfile2(baseimage, variables, repos, packages)
	end

	def workflow(environments) do
		jobs = for x <- environments, do: Generator.path x
		workflow2(jobs)
	end
end

defmodule ResolveDistro do
	def resolve(%{:compiler => comp, :qt => qt_version}) do
		resolve2(comp, qt_version)
	end
	defp resolve2({:gcc, _gcc_version}, _qt_version) do
		{:opensuse, 15.2}
	end
	defp resolve2({:clang, _clang_version}, _qt_version) do
		{:opensuse, 15.2}
	end
end

qt_versions = [{5, 12}, {5, 15}, {6, 0}]
gcc_versions = [7, 9, 10, 11]
clang_versions = [7, 9]

# environments_extra = [
# 	%{compiler: {:gcc, 4.8}, qt: 6},
#	%{compiler: {:gcc, 4.8}, qt: 7},
# 	%{compiler: {:gcc, 4.8}, qt: 8},
# 	%{compiler: {:gcc, 4.8}, qt: 9},
# 	%{compiler: {:gcc, 4.8}, qt: 10},
# 	%{compiler: {:gcc, 4.8}, qt: 11},
# ]
environments_extra = []

compilers = (for x <- gcc_versions, do: {:gcc, x}) ++ (for x <- clang_versions, do: {:clang, x})
environments = (for comp <- compilers, qt <- qt_versions, do: %{:compiler => comp, :qt => qt}) ++ environments_extra
environments_and_distros = for x <- environments, do: {x, ResolveDistro.resolve x}

Enum.map(environments_and_distros, fn {env, distro} -> path = Generator.path(env); :ok = File.mkdir_p(path); :ok = File.write(Path.join(path, "Dockerfile"), Generator.dockerfile(env, distro), [:binary]) end )

:ok = File.write(".github/workflows/dockerimage.yml", Generator.workflow(environments), [:binary])
