class DemoDataController < ApplicationController
  def index
    #@items = DemoData.all(:order => "created_at desc")[1..-1]
    @items = DemoData.all(:order => "created_at desc")[-1..-1]
  end

  def spy
    #@item = DemoData.first(:order => "created_at desc")
    @items = DemoData.all
    @item = @items[rand(@items.size)]
    render :layout => false
  end


end
