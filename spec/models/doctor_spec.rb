require 'rails_helper'

RSpec.describe Doctor do
  before(:each) do
    @hospital1 = Hospital.create(name: "U of U Hospital")
    @hospital2 = Hospital.create(name: "Central Piedmont Hospital")
    
    @doctor1 = @hospital1.doctors.create(name: "Dr. Belongea", specialty: "Osteopathic Medicine", university: "Stanford")
    @doctor2 = @hospital1.doctors.create(name: "Dr. Lucero", specialty: "Osteopathic Medicine", university: "VMA")

    @patient1 = Patient.create(name: "Alvin", age: 31)
    @patient2 = Patient.create(name: "Parker", age: 33)
    @patient3 = Patient.create(name: "Erin", age: 28)
    @patient4 = Patient.create(name: "Maddie", age: 29)
    @patient5 = Patient.create(name: "Shayne", age: 25)
    @patient6 = Patient.create(name: "Johnny", age: 27)
    @patient7 = Patient.create(name: "Billy", age: 16)
    @patient8 = Patient.create(name: "James", age: 9)

    @doctor1.patients << @patient1
    @doctor1.patients << @patient2
    @doctor1.patients << @patient3

    @doctor2.patients << @patient1
    @doctor2.patients << @patient2
    @doctor2.patients << @patient3
  end

  it { should belong_to :hospital }
  it { should have_many :doctor_patients }
  it { should have_many(:patients).through(:doctor_patients)}
  
  it "patient_count " do
    result = Doctor.patient_count(@hospital1.id)

    expect(result).to include(@doctor1)
    expect(result).to include(@doctor2)

    expect(result.map(&:name)).to eq([@doctor1.name, @doctor2.name])
    expect(result.map(&:patient_count)).to eq([3, 3])

    @doctor1.patients << @patient4
    @doctor1.patients << @patient5

    new_result = Doctor.patient_count(@hospital1.id)
    expect(new_result.map(&:patient_count)).to eq([5, 3])
  end
end