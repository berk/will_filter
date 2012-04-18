require File.expand_path('../../../spec_helper', File.dirname(__FILE__))

describe WillFilter::ActiveRecordExtension do
  describe 'filter' do

    before :all do
      5.times {|i| User.create(:first_name => "User #{i}")}
    end

    after :all do
      User.delete_all
    end

    context "filtering with no params" do
      it "should return all of the results" do
        User.filter(:params => {}).total_count.should == User.count
      end
    end

    context "filtering with is operator" do
      it "should return a single result" do
        User.filter(:params => {:wf_c0 => "first_name", :wf_o0 => "is", :wf_v0_0 => "User 1"}).total_count.should == 1
      end
    end
    
    context "filtering with like operator" do
      it "should return all matched results" do
        User.filter(:params => {:wf_c0 => "first_name", :wf_o0 => "contains", :wf_v0_0 => "User"}).total_count.should == User.count
      end
    end
    
    context "filtering with ends_with operator" do
      it "should return all matched results" do
        User.filter(:params => {:wf_c0 => "first_name", :wf_o0 => "ends_with", :wf_v0_0 => "4"}).total_count.should == 1
      end
    end

    context "filtering with starts_with operator" do
      it "should return all matched results" do
        User.filter(:params => {:wf_c0 => "first_name", :wf_o0 => "starts_with", :wf_v0_0 => "U"}).total_count.should == User.count
      end
    end
    
  end
end
