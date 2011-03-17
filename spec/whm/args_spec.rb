require 'spec_helper'
require 'lumberg/whm/args'

module Lumberg
  describe Whm::Args do
    context "required_parms" do
      it "raises an error when missing" do
        options = {:arg1 => true}
        args = lambda { 
          Whm::Args.new(options) do |c|
            c.requires :arg2
          end
        }
        expect { args.call }.to raise_error(WhmArgumentError, /Missing required parameter: arg2/)
      end

      it "does not raise an error with valid params" do
        options = {:arg1 => true}
        args =  Whm::Args.new(options) { |c|
          c.requires :arg1
        }

        args.required_params.should have(1).value
        args.required_params.should include(:arg1)
      end

      it "sets optional_params" do
        options = {:arg1 => true, :arg2 => 2}
        args =  Whm::Args.new(options) { |c|
          c.requires :arg1, :arg2
        }

        args.optional_params.should have(2).values
        args.required_params.should have(2).values

        args.optional_params.should include(*args.required_params)
      end

      it "does not set boolean_params" do
        options = {:arg1 => true, :arg2 => 2}
        args =  Whm::Args.new(options) { |c|
          c.requires :arg1, :arg2
        }

        args.boolean_params.should be_empty
      end
    end

    context "boolean_params" do
      it "raises an error when the param is not boolean" do
        options = {:arg1 => 'string'}
        args = lambda { 
          Whm::Args.new(options) do |c|
            c.booleans :arg1
          end
        }
        expect { args.call }.to raise_error(WhmArgumentError, /Boolean parameter must be.*: arg1/)
      end

      it "raises an error with boolean params" do
        options = {:arg1 => true}
        args =  Whm::Args.new(options) { |c|
          c.booleans :arg1
        }

        args.boolean_params.should have(1).value
        args.boolean_params.should include(:arg1)
      end

      it "sets optional_params" do
        options = {:arg1 => true, :arg2 => false}
        args =  Whm::Args.new(options) { |c|
          c.booleans :arg1, :arg2
        }

        args.optional_params.should have(2).values
        args.boolean_params.should have(2).values

        args.optional_params.should include(:arg1, :arg2)
      end

      it "sets required_params" do
        options = {:arg1 => true, :arg2 => false}
        args =  Whm::Args.new(options) { |c|
          c.booleans :arg1, :arg2
        }

        args.required_params.should be_empty
      end
    end

    context "optional_params" do
      it "raises an error with unknown params" do
        options = {:arg1 => true}
        args = lambda { 
          Whm::Args.new(options) do |c|
            c.optionals :arg2
          end
        }

        expect { args.call }.to raise_error(WhmArgumentError, /Not a valid parameter: arg1/)
      end

      it "does not raise an error with known params" do
        options = {:arg1 => true, :arg2 => 2}
        args =  Whm::Args.new(options) { |c|
          c.optionals :arg1, :arg2
        }

        args.optional_params.should have(2).values
        args.optional_params.should include(:arg1, :arg2)
      end

      it "does not set required_params" do
        options = {:arg1 => true, :arg2 => 2}
        args =  Whm::Args.new(options) { |c|
          c.optionals :arg1, :arg2
        }
        
        args.required_params.should be_empty
      end

      it "does not set boolean_params" do
        options = {:arg1 => true, :arg2 => 2}
        args =  Whm::Args.new(options) { |c|
          c.optionals :arg1, :arg2
        }
        
        args.boolean_params.should be_empty
      end
    end

    context "one_of" do
      it "allows one arg" do
        options = {:arg1 => true}
        args = lambda {
          Whm::Args.new(options) do |c|
            c.one_of :arg1
          end
        }

        expect { args.call }.to raise_error(WhmArgumentError, /One of requires two or more items/)
      end

      it "allows two or more args" do
        options = {:arg1 => true}

        args = Whm::Args.new(options) do |c|
          c.one_of :arg1, :arg2
        end

        args.one_of_params.should have(2).values
        args.one_of_params.should include(:arg1, :arg2)
      end

      it "does not allow 0 params" do
        options = {}
        args = lambda {
          Whm::Args.new(options) do |c|
            c.one_of :arg1, :arg2
          end
        }

        expect { args.call }.to raise_error(WhmArgumentError, /The parameters may include only one of 'arg1, arg2'/)
      end

      it "does not allow both args" do
        options = {:arg1 => true, :arg2 => 2}
        args = lambda {
          Whm::Args.new(options) do |c|
            c.one_of :arg1, :arg2
          end
        }

        expect { args.call }.to raise_error(WhmArgumentError, /The parameters may include only one of 'arg1, arg2'/)
      end
    end
  end
end
