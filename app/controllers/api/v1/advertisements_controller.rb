module Api
    module V1
      class AdvertisementsController < ApiController
        # before_action :authenticate, only: %i[create update destroy]
        protect_from_forgery with :null_session
        
  
        # GET /api/v1/Advertisements
        def index
          render json: serializer(Advertisements, options)
        end
        
        # GET /api/v1/Advertisements/:slug
        def show
          render json: serializer(advertisement, options)
        end
  
        # POST /api/v1/Advertisements
        def create
          advertisement = Advertisement.new(airline_params)
  
          if advertisement.save
            render json: serializer(advertisement)
          else
            render json: errors(advertisement), status: 422
          end
        end
  
        # PATCH /api/v1/Advertisements/:slug
        def update
          advertisement = Advertisement.find_by(slug: params[:slug])
  
          if advertisement.update(airline_params)
            render json: serializer(advertisement, options)
          else
            render json: errors(advertisement), status: 422
          end
        end
  
        # DELETE /api/v1/Advertisements/:slug
        def destroy
          if advertisement.destroy
            head :no_content
          else
            render json: errors(advertisement), status: 422
          end
        end
  
        private
  
        # Used For compound documents with fast_jsonapi
        def options
          @options ||= { include: %i[reviews] }
        end
  
        # Get all Advertisements
        def Advertisements
          @Advertisements ||= Advertisement.includes(reviews: :user).all
        end
  
        # Get a specific advertisement
        def advertisement
          @advertisement ||= Advertisement.includes(reviews: :user).find_by(slug: params[:slug])
        end
  
        # Strong params
        def airline_params
          params.require(:advertisement).permit(:name, :image_url)
        end
  
        # fast_jsonapi serializer
        def serializer(records, options = {})
          Advertisementserializer
            .new(records, options)
            .serialized_json
        end
  
        # Errors
        def errors(record)
          { errors: record.errors.messages }
        end
      end
    end
  end
  