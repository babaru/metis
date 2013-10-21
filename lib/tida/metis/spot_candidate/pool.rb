module Tida
  module Metis
    module SpotCandidate
      class Pool
        attr_reader :pool
        def initialize(session)
          session[:spot_candidate_pool] = {} unless session[:spot_candidate_pool]
          @pool = session[:spot_candidate_pool]
        end

        def add(spot, count, is_on_house)
          key = get_key(spot.id, is_on_house)
          item = get_item(spot.medium_id, key)
          medium_pool = get_medium_pool(spot.medium_id)
          if item
            item[:count] += count
          else
            medium_pool[key] = {spot_id: spot.id, spot_name: spot.name, channel_name: spot.channel.name, medium_id: spot.medium_id, medium_name: spot.medium.name, count: count, is_on_house: is_on_house}
          end
          medium_pool[key]
        end

        def remove(medium_id, key)
          medium_pool = get_medium_pool(medium_id)
          medium_pool.delete(key)
          @pool.delete(medium_id.to_s) if medium_pool.count == 0
        end

        def change(medium_id, spot_id, is_on_house, new_count, new_is_on_house)
          key = get_key(spot_id, is_on_house)
          new_key = get_key(spot_id, new_is_on_house)
          medium_pool = get_medium_pool(medium_id)
          if key == new_key
            item = get_item(medium_id, key)
            if item
              item[:count] = new_count
            end
          else
            item = medium_pool[key]
            medium_pool.delete(key)
            if item
              item[:count] = new_count
              item[:is_on_house] = new_is_on_house
              medium_pool[new_key] = item
            end
          end
          medium_pool[new_key]
        end

        private

        def get_medium_pool(medium_id)
          key = medium_id.to_s
          @pool[key] = {} unless @pool[key]
          @pool[key]
        end

        def get_item(medium_id, key)
          medium_pool = get_medium_pool(medium_id)
          medium_pool[key]
        end

        def get_key(spot_id, is_on_house)
          "#{spot_id}#{is_on_house}"
        end
      end
    end
  end
end
