defmodule Loan.LoansTest do
  use Loan.DataCase

  alias Loan.Loans

  describe "client_details" do
    alias Loan.Loans.ClientDetail

    @valid_attrs %{active: true, day_not_paid: "120.5", guarantor: "some guarantor", identification_number: "some identification_number", interest: "120.5", mobile_number: "some mobile_number", name: "some name", paydate: ~D[2010-04-17], penalties: "120.5", principal_amount: "120.5", rate: "120.5", registration_number: "some registration_number", residence: "some residence", total: "120.5"}
    @update_attrs %{active: false, day_not_paid: "456.7", guarantor: "some updated guarantor", identification_number: "some updated identification_number", interest: "456.7", mobile_number: "some updated mobile_number", name: "some updated name", paydate: ~D[2011-05-18], penalties: "456.7", principal_amount: "456.7", rate: "456.7", registration_number: "some updated registration_number", residence: "some updated residence", total: "456.7"}
    @invalid_attrs %{active: nil, day_not_paid: nil, guarantor: nil, identification_number: nil, interest: nil, mobile_number: nil, name: nil, paydate: nil, penalties: nil, principal_amount: nil, rate: nil, registration_number: nil, residence: nil, total: nil}

    def client_detail_fixture(attrs \\ %{}) do
      {:ok, client_detail} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loans.create_client_detail()

      client_detail
    end

    test "list_client_details/0 returns all client_details" do
      client_detail = client_detail_fixture()
      assert Loans.list_client_details() == [client_detail]
    end

    test "get_client_detail!/1 returns the client_detail with given id" do
      client_detail = client_detail_fixture()
      assert Loans.get_client_detail!(client_detail.id) == client_detail
    end

    test "create_client_detail/1 with valid data creates a client_detail" do
      assert {:ok, %ClientDetail{} = client_detail} = Loans.create_client_detail(@valid_attrs)
      assert client_detail.active == true
      assert client_detail.day_not_paid == Decimal.new("120.5")
      assert client_detail.guarantor == "some guarantor"
      assert client_detail.identification_number == "some identification_number"
      assert client_detail.interest == Decimal.new("120.5")
      assert client_detail.mobile_number == "some mobile_number"
      assert client_detail.name == "some name"
      assert client_detail.paydate == ~D[2010-04-17]
      assert client_detail.penalties == Decimal.new("120.5")
      assert client_detail.principal_amount == Decimal.new("120.5")
      assert client_detail.rate == Decimal.new("120.5")
      assert client_detail.registration_number == "some registration_number"
      assert client_detail.residence == "some residence"
      assert client_detail.total == Decimal.new("120.5")
    end

    test "create_client_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loans.create_client_detail(@invalid_attrs)
    end

    test "update_client_detail/2 with valid data updates the client_detail" do
      client_detail = client_detail_fixture()
      assert {:ok, client_detail} = Loans.update_client_detail(client_detail, @update_attrs)
      assert %ClientDetail{} = client_detail
      assert client_detail.active == false
      assert client_detail.day_not_paid == Decimal.new("456.7")
      assert client_detail.guarantor == "some updated guarantor"
      assert client_detail.identification_number == "some updated identification_number"
      assert client_detail.interest == Decimal.new("456.7")
      assert client_detail.mobile_number == "some updated mobile_number"
      assert client_detail.name == "some updated name"
      assert client_detail.paydate == ~D[2011-05-18]
      assert client_detail.penalties == Decimal.new("456.7")
      assert client_detail.principal_amount == Decimal.new("456.7")
      assert client_detail.rate == Decimal.new("456.7")
      assert client_detail.registration_number == "some updated registration_number"
      assert client_detail.residence == "some updated residence"
      assert client_detail.total == Decimal.new("456.7")
    end

    test "update_client_detail/2 with invalid data returns error changeset" do
      client_detail = client_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Loans.update_client_detail(client_detail, @invalid_attrs)
      assert client_detail == Loans.get_client_detail!(client_detail.id)
    end

    test "delete_client_detail/1 deletes the client_detail" do
      client_detail = client_detail_fixture()
      assert {:ok, %ClientDetail{}} = Loans.delete_client_detail(client_detail)
      assert_raise Ecto.NoResultsError, fn -> Loans.get_client_detail!(client_detail.id) end
    end

    test "change_client_detail/1 returns a client_detail changeset" do
      client_detail = client_detail_fixture()
      assert %Ecto.Changeset{} = Loans.change_client_detail(client_detail)
    end
  end
end
