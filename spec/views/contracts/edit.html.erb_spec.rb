require 'spec_helper'

describe "contracts/edit" do
  before(:each) do
    @contract = assign(:contract, stub_model(Contract,
      :user_id => 1,
      :name => "MyString",
      :price => 1.5,
      :start_date => "MyString",
      :end_date => "MyString"
    ))
  end

  it "renders the edit contract form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contracts_path(@contract), :method => "post" do
      assert_select "input#contract_user_id", :name => "contract[user_id]"
      assert_select "input#contract_name", :name => "contract[name]"
      assert_select "input#contract_price", :name => "contract[price]"
      assert_select "input#contract_startdate", :name => "contract[startdate]"
      assert_select "input#contract_endate", :name => "contract[endate]"
    end
  end
end
