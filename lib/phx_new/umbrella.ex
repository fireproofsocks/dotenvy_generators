defmodule Phx.New.Umbrella do
  @moduledoc false
  use Phx.New.Generator
  alias Phx.New.{Ecto, Web, Project, Mailer}

  # template(:new, [
  #   {:eex, :project,
  #    "phx_umbrella/gitignore": ".gitignore",
  #    "phx_umbrella/config/config.exs": "config/config.exs",
  #    "phx_umbrella/config/dev.exs": "config/dev.exs",
  #    "phx_umbrella/config/test.exs": "config/test.exs",
  #    "phx_umbrella/config/prod.exs": "config/prod.exs",
  #    "phx_umbrella/config/runtime.exs": "config/runtime.exs",
  #    "phx_umbrella/mix.exs": "mix.exs",
  #    "phx_umbrella/README.md": "README.md",
  #    "phx_umbrella/formatter.exs": ".formatter.exs"},
  #   {:config, :project, "phx_umbrella/config/extra_config.exs": "config/config.exs"}
  # ])

  template(:new, [
    # {:config, :project,
    #  "phx_single/config/config.exs": "config/config.exs",
    #  "phx_single/config/dev.exs": "config/dev.exs",
    #  "phx_single/config/prod.exs": "config/prod.exs",
    #  "phx_single/config/runtime.exs": "config/runtime.exs",
    #  "phx_single/config/test.exs": "config/test.exs"},
    {
      :eex,
      :project,
      "phx_single/envs/.env": "envs/.env",
      "phx_single/envs/.dev.env": "envs/.dev.env",
      "phx_single/envs/.test.env": "envs/.test.env",
      "phx_single/envs/.prod.env": "envs/.prod.env"
    },
      {:eex, :project,
     "phx_umbrella/gitignore": ".gitignore",
     "phx_umbrella/config/config.exs": "config/config.exs",
     "phx_umbrella/config/dev.exs": "config/dev.exs",
     "phx_umbrella/config/test.exs": "config/test.exs",
     "phx_umbrella/config/prod.exs": "config/prod.exs",
     "phx_umbrella/config/runtime.exs": "config/runtime.exs",
     "phx_umbrella/mix.exs": "mix.exs",
     "phx_umbrella/README.md": "README.md",
     "phx_umbrella/formatter.exs": ".formatter.exs"}
    # {:eex, :web,
    #  "phx_single/lib/app_name/application.ex": "lib/:app/application.ex",
    #  "phx_single/lib/app_name.ex": "lib/:app.ex",
    #  "phx_web/controllers/error_json.ex": "lib/:lib_web_name/controllers/error_json.ex",
    #  "phx_web/endpoint.ex": "lib/:lib_web_name/endpoint.ex",
    #  "phx_web/router.ex": "lib/:lib_web_name/router.ex",
    #  "phx_web/telemetry.ex": "lib/:lib_web_name/telemetry.ex",
    #  "phx_single/lib/app_name_web.ex": "lib/:lib_web_name.ex",
    #  "phx_single/mix.exs": "mix.exs",
    #  "phx_single/README.md": "README.md",
    #  "phx_single/formatter.exs": ".formatter.exs",
    #  "phx_single/gitignore": ".gitignore",
    #  "phx_test/support/conn_case.ex": "test/support/conn_case.ex",
    #  "phx_single/test/test_helper.exs": "test/test_helper.exs",
    #  "phx_test/controllers/error_json_test.exs":
    #    "test/:lib_web_name/controllers/error_json_test.exs"},
    # {:keep, :web,
    #  "phx_web/controllers": "lib/:lib_web_name/controllers",
    #  "phx_test/controllers": "test/:lib_web_name/controllers"}
  ])


  def prepare_project(%Project{app: app} = project) when not is_nil(app) do
    project
    |> put_app()
    |> put_web()
    |> put_root_app()
  end

  defp put_app(project) do
    project_path = Path.expand(project.base_path <> "_umbrella")
    app_path = Path.join(project_path, "apps/#{project.app}")

    %Project{project | in_umbrella?: true, app_path: app_path, project_path: project_path}
  end

  def put_web(%Project{app: app, opts: opts} = project) do
    web_app = :"#{app}_web"
    web_namespace = Module.concat([opts[:web_module] || "#{project.app_mod}Web"])

    %Project{
      project
      | web_app: web_app,
        lib_web_name: web_app,
        web_namespace: web_namespace,
        generators: [context_app: :"#{app}"],
        web_path: Path.join(project.project_path, "apps/#{web_app}/")
    }
  end

  defp put_root_app(%Project{app: app} = project) do
    %Project{
      project
      | root_app: :"#{app}_umbrella",
        root_mod: Module.concat(project.app_mod, "Umbrella")
    }
  end

  def generate(%Project{} = project) do
    if in_umbrella?(project.project_path) do
      Mix.raise("Unable to nest umbrella project within apps")
    end

    copy_from(project, __MODULE__, :new)

    project
    |> Web.generate()
    |> Ecto.generate()
    |> maybe_generate_mailer()
  end

  defp maybe_generate_mailer(project) do
    if Project.mailer?(project) do
      Mailer.generate(project)
    else
      project
    end
  end
end
