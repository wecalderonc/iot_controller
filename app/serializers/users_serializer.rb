class UsersSerializer < ActiveModel::Serializer
  attributes  :first_name,
              :last_name,
              :email,
              :phone,
              :gender,
              :id_number,
              :id_type

end
