defmodule Tasks.Hash do

  def hash(value) do
    Base.encode16(:crypto.hash(:sha512, value))
  end

  end