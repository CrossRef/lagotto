object false
cache ['v5', @status]

node(:error) { nil }

node :data do
  partial "v5/status/base", :object => @status
end
