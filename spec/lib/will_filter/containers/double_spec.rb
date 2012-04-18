require File.expand_path('../../../spec_helper', File.dirname(__FILE__))

describe WillFilter::Containers::Double do
  describe '#filter' do
    context "filtering with is operator" do

      before :all do
        5.times {|i| User.create(:first_name => "User #{i}")}
      end

      after :all do
        User.delete_all
      end

      it "should return a single result" do
        User.filter(:params => {:wf_c0 => "first_name", :wf_o0 => "is", :wf_v0_0 => "User 1"}).total_count.should == 1
      end
    end
    
  end
end
