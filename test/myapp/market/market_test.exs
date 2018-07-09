defmodule Myapp.MarketTest do
  use Myapp.DataCase

  alias Myapp.Market

  describe "leads" do
    alias Myapp.Market.Lead

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def lead_fixture(attrs \\ %{}) do
      {:ok, lead} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Market.create_lead()

      lead
    end

    test "list_leads/0 returns all leads" do
      lead = lead_fixture()
      assert Market.list_leads() == [lead]
    end

    test "get_lead!/1 returns the lead with given id" do
      lead = lead_fixture()
      assert Market.get_lead!(lead.id) == lead
    end

    test "create_lead/1 with valid data creates a lead" do
      assert {:ok, %Lead{} = lead} = Market.create_lead(@valid_attrs)
      assert lead.name == "some name"
    end

    test "create_lead/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Market.create_lead(@invalid_attrs)
    end

    test "update_lead/2 with valid data updates the lead" do
      lead = lead_fixture()
      assert {:ok, lead} = Market.update_lead(lead, @update_attrs)
      assert %Lead{} = lead
      assert lead.name == "some updated name"
    end

    test "update_lead/2 with invalid data returns error changeset" do
      lead = lead_fixture()
      assert {:error, %Ecto.Changeset{}} = Market.update_lead(lead, @invalid_attrs)
      assert lead == Market.get_lead!(lead.id)
    end

    test "delete_lead/1 deletes the lead" do
      lead = lead_fixture()
      assert {:ok, %Lead{}} = Market.delete_lead(lead)
      assert_raise Ecto.NoResultsError, fn -> Market.get_lead!(lead.id) end
    end

    test "change_lead/1 returns a lead changeset" do
      lead = lead_fixture()
      assert %Ecto.Changeset{} = Market.change_lead(lead)
    end
  end
end
