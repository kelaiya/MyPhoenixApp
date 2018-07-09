defmodule Myapp.MarketingTest do
  use Myapp.DataCase

  alias Myapp.Marketing

  describe "store" do
    alias Myapp.Marketing.Store

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def store_fixture(attrs \\ %{}) do
      {:ok, store} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Marketing.create_store()

      store
    end

    test "list_store/0 returns all store" do
      store = store_fixture()
      assert Marketing.list_store() == [store]
    end

    test "get_store!/1 returns the store with given id" do
      store = store_fixture()
      assert Marketing.get_store!(store.id) == store
    end

    test "create_store/1 with valid data creates a store" do
      assert {:ok, %Store{} = store} = Marketing.create_store(@valid_attrs)
      assert store.name == "some name"
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marketing.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = store_fixture()
      assert {:ok, store} = Marketing.update_store(store, @update_attrs)
      assert %Store{} = store
      assert store.name == "some updated name"
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = store_fixture()
      assert {:error, %Ecto.Changeset{}} = Marketing.update_store(store, @invalid_attrs)
      assert store == Marketing.get_store!(store.id)
    end

    test "delete_store/1 deletes the store" do
      store = store_fixture()
      assert {:ok, %Store{}} = Marketing.delete_store(store)
      assert_raise Ecto.NoResultsError, fn -> Marketing.get_store!(store.id) end
    end

    test "change_store/1 returns a store changeset" do
      store = store_fixture()
      assert %Ecto.Changeset{} = Marketing.change_store(store)
    end
  end
end
