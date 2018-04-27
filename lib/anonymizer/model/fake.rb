# Generator to fake data
class Fake
  def self.user
    firstname = FFaker::Name.first_name
    lastname = FFaker::Name.last_name

    prepare_user_hash firstname, lastname
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def self.create_fake_user_table(database)
    database.create_table :fake_user do
      primary_key :id
      String :firstname
      String :lastname
      String :login
      String :email
      String :telephone
      String :company
      String :street
      String :postcode
      String :city
      String :vat_id
      String :ip
      String :quote
      String :website
      String :iban
      String :regon
      String :pesel
      String :json
    end
  end

  def self.prepare_user_hash(firstname, lastname)
    {
      firstname: firstname,
      lastname: lastname,
      email: add_uniq_to_email(FFaker::Internet.email("#{firstname} #{lastname}")),
      login: add_uniq_to_end_of(FFaker::Internet.user_name("#{firstname} #{lastname}")),
      telephone: FFaker::PhoneNumber.phone_number,
      company: FFaker::Company.name,
      street: FFaker::Address.street_name,
      postcode: FFaker::AddressCHIT.postal_code,
      city: FFaker::Address.city,
      vat_id: FFaker::CompanyIT.partita_iva,
      ip: FFaker::Internet.ip_v4_address,
      quote: FFaker::HealthcareIpsum.phrase,
      website: FFaker::Internet.domain_name,
      iban: '',
      regon: generate_regon,
      pesel: FFaker::Identification.ssn,
      json: '{}'
    }
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def self.add_uniq_to_email(email)
    email.sub! '@', '$uniq$@'
  end

  def self.add_uniq_to_end_of(string)
    string + '$uniq$'
  end

  def self.generate_regon
    regon = district_number

    6.times do
      regon += Random.rand(0..9).to_s
    end

    sum = sum_for_wigths(regon, regon_weight)
    validation_mumber = (sum % 11 if sum % 11 != 10) || 0

    regon + validation_mumber.to_s
  end

  def self.regon_weight
    [8, 9, 2, 3, 4, 5, 6, 7]
  end

  def self.sum_for_wigths(numbers, weight_array)
    sum = 0
    numbers[0, numbers.length - 1].split('').each_with_index do |number, index|
      sum += number.to_i * weight_array[index]
    end

    sum
  end

  def self.district_number
    %w[01 03 47 49 91 93 95 97].sample
  end
end
