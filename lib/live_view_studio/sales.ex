defmodule LiveViewStudio.Sales do
  def generate_sales() do
    Enum.random(100..1000)
  end

  def generate_satisfaction() do
    Enum.random(90..100)
  end

  def generate_orders() do
    Enum.random(5..20)
  end
end
