module API
  module V1
    class Base < Grape::API
      mount API::V1::Uplinks
      mount API::V1::Things

      add_swagger_documentation base_path: "/api",
                                api_version: 'v1',
                                hide_documentation_path: true
    end
  end
end
