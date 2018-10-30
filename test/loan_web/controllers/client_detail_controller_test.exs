defmodule LoanWeb.ClientDetailControllerTest do
  use LoanWeb.ConnCase

  alias Loan.Loans

  @create_attrs %{active: true, day_not_paid: "120.5", guarantor: "some guarantor", identification_number: "some identification_number", interest: "120.5", mobile_number: "some mobile_number", name: "some name", paydate: ~D[2010-04-17], penalties: "120.5", principal_amount: "120.5", rate: "120.5", registration_number: "some registration_number", residence: "some residence", total: "120.5"}
  @update_attrs %{active: false, day_not_paid: "456.7", guarantor: "some updated guarantor", identification_number: "some updated identification_number", interest: "456.7", mobile_number: "some updated mobile_number", name: "some updated name", paydate: ~D[2011-05-18], penalties: "456.7", principal_amount: "456.7", rate: "456.7", registration_number: "some updated registration_number", residence: "some updated residence", total: "456.7"}
  @invalid_attrs %{active: nil, day_not_paid: nil, guarantor: nil, identification_number: nil, interest: nil, mobile_number: nil, name: nil, paydate: nil, penalties: nil, principal_amount: nil, rate: nil, registration_number: nil, residence: nil, total: nil}

  def fixture(:client_detail) do
    {:ok, client_detail} = Loans.create_client_detail(@create_attrs)
    client_detail
  end

  describe "index" do
    test "lists all client_details", %{conn: conn} do
      conn = get conn, client_detail_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Client details"
    end
  end

  describe "new client_detail" do
    test "renders form", %{conn: conn} do
      conn = get conn, client_detail_path(conn, :new)
      assert html_response(conn, 200) =~ "New Client detail"
    end
  end

  describe "create client_detail" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, client_detail_path(conn, :create), client_detail: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == client_detail_path(conn, :show, id)

      conn = get conn, client_detail_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Client detail"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, client_detail_path(conn, :create), client_detail: @invalid_attrs
      assert html_response(conn, 200) =~ "New Client detail"
    end
  end

  describe "edit client_detail" do
    setup [:create_client_detail]

    test "renders form for editing chosen client_detail", %{conn: conn, client_detail: client_detail} do
      conn = get conn, client_detail_path(conn, :edit, client_detail)
      assert html_response(conn, 200) =~ "Edit Client detail"
    end
  end

  describe "update client_detail" do
    setup [:create_client_detail]

    test "redirects when data is valid", %{conn: conn, client_detail: client_detail} do
      conn = put conn, client_detail_path(conn, :update, client_detail), client_detail: @update_attrs
      assert redirected_to(conn) == client_detail_path(conn, :show, client_detail)

      conn = get conn, client_detail_path(conn, :show, client_detail)
      assert html_response(conn, 200) =~ "some updated guarantor"
    end

    test "renders errors when data is invalid", %{conn: conn, client_detail: client_detail} do
      conn = put conn, client_detail_path(conn, :update, client_detail), client_detail: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Client detail"
    end
  end

  describe "delete client_detail" do
    setup [:create_client_detail]

    test "deletes chosen client_detail", %{conn: conn, client_detail: client_detail} do
      conn = delete conn, client_detail_path(conn, :delete, client_detail)
      assert redirected_to(conn) == client_detail_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, client_detail_path(conn, :show, client_detail)
      end
    end
  end

  defp create_client_detail(_) do
    client_detail = fixture(:client_detail)
    {:ok, client_detail: client_detail}
  end
end
