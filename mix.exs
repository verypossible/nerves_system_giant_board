defmodule NervesSystemGiant.MixProject do
  use Mix.Project

  @github_organization "verypossible-labs"
  @app :nerves_system_giant
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: [loadconfig: [&bootstrap/1]],
      docs: [extras: ["README.md"], main: "readme"]
    ]
  end

  def application do
    []
  end

  defp bootstrap(args) do
    System.put_env("MIX_TARGET", "bbb")
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :system,
      artifact_sites: [
        {:github_releases, "nerves-project/#{@app}"}
      ],
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.6", runtime: false},
      {:nerves_system_br, "1.11.4", runtime: false},
      {:nerves_toolchain_arm_unknown_linux_gnueabihf, "~> 1.3.0", runtime: false},
      {:nerves_system_linter, "~> 0.3.0", runtime: false},
      {:ex_doc, "~> 0.18", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Nerves System - SAM A5D2
    """
  end

  defp package do
    [
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/#{@github_organization}/#{@app}"}
    ]
  end

  defp package_files do
    [
      "CHANGELOG.md",
      "fwup_include",
      "fwup.conf",
      "fwup-revert.conf",
      "LICENSE",
      "linux-4.4.defconfig",
      "rootfs_overlay",
      "mix.exs",
      "nerves_defconfig",
      "post-createfs.sh",
      "README.md",
      "VERSION"
    ]
  end
end
