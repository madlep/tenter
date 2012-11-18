# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard 'shell' do
  watch(/src\/.*/) { `make eunit` }
  watch(/test\/.*/) { `make eunit` }
end
