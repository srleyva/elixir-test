defmodule MinimalServer.Router do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/" do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(message()))
    end

    get "/:id" do
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(message_with_param(id)))
    end

    defp message_with_param(param) do
        %{
            response_type: "in_channel",
            text: "Hello: #{param} from BOT :)"
        }
    end

    defp message do
        %{
          response_type: "in_channel",
          text: "Hello from BOT :)"
        }
    end
end