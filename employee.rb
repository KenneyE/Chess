class Employee
  attr_accessor :title, :salary, :boss, :name

  def initialize(name = "Employee", title = "Employee", salary = 40000, boss = nil)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    self.salary * multiplier
  end

end

class Manager < Employee

  attr_accessor :employees

  def initialize(employees = [])
    super
    @employees = employees
    add_employees(employees)
  end

  def add_employees(employees)
    self.employees = employees
    self.employees.each {|employee| employee.boss = self}
  end


  def bonus(multiplier)
    b = 0

    self.employees.each do |employee|
      b += employee.salary * multiplier
    end

    b
  end



end
