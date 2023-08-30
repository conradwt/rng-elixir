defmodule RngWeb.RngController do
  use RngWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(200, "RNG running on #{:net_adm.localhost()}\n")
  end

  def rng(conn, %{"how_many_bytes" => how_many_bytes}) do
    # simulate a bit of delay.
    Process.sleep(100)

    {:ok, result} =
      File.open("/dev/urandom", [:read], fn file ->
        IO.read(file, String.to_integer(how_many_bytes))
      end)

    conn
    |> put_resp_content_type("application/octet-stream")
    |> send_resp(200, "#{result |> String.graphemes()}")
  end
end
