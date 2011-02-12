Rails::Application.routes.draw do
  match '/th/*path', :controller => "th", :action => "deliver_crop"
end
