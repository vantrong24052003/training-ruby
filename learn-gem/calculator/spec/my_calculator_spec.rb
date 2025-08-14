require "my_gem"
# spec/my_calculator_spec.rb
RSpec.describe MyGem do
  it "has a version number" do
    expect(MyGem::VERSION).not_to be nil
  end

  describe MyGem::Calculator do
    let(:calculator) { MyGem::Calculator.new }

    it "adds two numbers" do
      expect(calculator.add(2, 3)).to eq(5)
    end

    it "subtracts two numbers" do
      expect(calculator.subtract(5, 2)).to eq(3)
    end

    it "multiplies two numbers" do
      expect(calculator.multiply(2, 3)).to eq(6)
    end

    it "divides two numbers" do
      expect(calculator.divide(6, 2)).to eq(3.0)
    end

    it "raises error when dividing by zero" do
      expect { calculator.divide(6, 0) }.to raise_error(MyGem::Error)
    end
  end
end