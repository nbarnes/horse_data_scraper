
class Horse

  attr_accessor :name, :registration_num, :sex, :color, :birth_year, :sire
  attr_accessor :dam, :dam_sire, :breeder, :performance_records_available

  def initialize
  end

  def to_hash
    hash = {}
    instance_variables.each do |var|
      hash[var.to_s.delete("@")] = instance_variable_get(var)
    end
    return hash
  end


  def to_json(options=nil)
    return JSON.generate(to_hash)
  end

end
