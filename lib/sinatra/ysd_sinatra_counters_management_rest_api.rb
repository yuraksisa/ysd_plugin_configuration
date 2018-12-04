module Sinatra
  module YSD
    module CountersManagementRESTApi
   
      def self.registered(app)

        #
        # Updates a counter
        #
        app.put "/api/counter", :allowed_usergroups => ['staff','webmaster'] do
          request.body.rewind
          counter_request = JSON.parse(URI.unescape(request.body.read))
          
          if counter = SystemConfiguration::Counter.get(counter_request['id'])
          	if counter_request['serie'] and counter_request['serie'].empty?
              counter.serie = nil
            else
              counter.serie = counter_request['serie']
            end    		
            counter.value=counter_request['value']
            counter.save
          end    

          status 200
          content_type :json
          counter.to_json
        end
       
      end

    end
  end
end      	