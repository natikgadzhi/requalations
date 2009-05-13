module Requalations
  
  # Requalations matrix module
  # Defines additional matrix methods and operations
  #
  module Matrix
    # Retrieves square matrix size
    # 
    def n
      raise StandardError.new("The matrix should be square to use #n" ) unless square?
      column_size
    end
    
    # Swaps two rows
    #
    def swap_rows!( from, to)
      to_row = row(to)
      
      set_row( to, row(from))
      set_row( from, to_row)
    end
    
    # Allows you to set matrix elements one by one
    # 
    def []=(row, column, value)
      @rows[row][column] = value
    end
    
    # These two methods are equal to []=
    #  
    alias_method :set_element, :[]=
    alias_method :set_component, :[]= 
    
    
    # Find the matrix eigenvalues using rotations jacobi method
    # 
    def eigenvalues_using_rotations( eps = 0.1 )
      # Подготовка
      n = self.column_size
      # матрица для обработки, первичная — равна этой. следующей итерации — по умолчанию, пустая. мы получим ее умножением. 
      a = self.clone
      a_next = ::Matrix.identity(n)
      eigen_vectors = ::Matrix.identity(n)
      
      # кол-во итераций и критерий завершения процесса — сумма квадратов наддиагональных элементов
      iterations_count = 0
      elements_sum = 0
      
      begin
        # Обновим итерационные данные
        elements_sum = 0
        iterations_count += 1
        max_element_value = 0
        
        # 1) Найти наддиоганальный максимальный элемент
        # Укоротить! 
        for i in 0...n
          for j in 0...n
            if i < j 
              if max_element_value < a[i,j].abs
                max_element_value = a[i,j].abs
                max_element_i = i
                max_element_j = j
              end
            end
          end
        end
    
        # 2) Построить матрицу U вращения
        # находим угол
        if a[max_element_i, max_element_i] == a[max_element_j, max_element_j]
          phi_angle = Math::PI/4
        else
          phi_angle = 0.5 * Math.atan(2 * max_element_value / (a[max_element_i, max_element_i] - a[max_element_j, max_element_j]))
        end
        # строим матрицу
        u_matrix = ::Matrix.identity( n )
        # диагональные
        u_matrix[max_element_i, max_element_i] = u_matrix[max_element_j, max_element_j] = Math.cos(phi_angle)
        # максимальный элемент и его симметричный
        u_matrix[max_element_i, max_element_j] = - Math.sin(phi_angle)
        u_matrix[max_element_j, max_element_i] = Math.sin(phi_angle)
        
        # puts u_matrix
        #puts "<br><br><br>"
        
        # умножение и получение матрицы следующей итерации 
        a_next = u_matrix.t * a * u_matrix
        a = a_next.clone
        
        # А заодно матрицу собственных векторов умножим
        eigen_vectors = eigen_vectors * u_matrix
        
        #puts "at this point we have: iteration #{iterations_count}, matrix #{a_next}<br><br>"
        
        # считаем сумму элементов
        for i in 0...n
          for j in 0...n
            if i < j
              elements_sum += a_next[i,j] ** 2
            end
          end
        end 
        elements_sum = elements_sum ** 0.5
        
        # Если сумма квадратов наддиагональных элементов больше точности — повторить. Иначе — выйти из цикла. 
      end while elements_sum > eps 
      
      # После цикла, в a_next на диагонали лежат собственные значения исходной матрицы
      @eigen_values = []
      for i in 0...n do
        @eigen_values[i] = a_next[i,i]
      end
      
      # a_next
      [ @eigen_values, eigen_vectors.column_vectors, iterations_count]
    end
    
    ## Private instance methods
    ## --------------------------------------------------------------------------------
    private
    
    # Sets row to supplied vector
    #
    def set_row( row_index, vector )
      @rows[row_index] = vector.to_a
    end

  end
  
  module MatrixClassMethods
    def blank (size)
      row = Array.new(size, 0)
      zero_rows = []
      size.times do |i|
        zero_rows[i] = row
      end
      ::Matrix.rows(zero_rows)
    end
  end
end

# If Matrix is already initialized, include Requalations::Matrix into the original one
Matrix.send( :include, ::Requalations::Matrix ) if defined?( ::Matrix )
Matrix.send( :extend, ::Requalations::MatrixClassMethods ) if defined?( ::Matrix )

# Also include additional matrix modules. 
# There are some modules for extended matrix functionality in ./lib/matrix directory 
matrix_directory = File.dirname(__FILE__) + "/matrix"
Dir.foreach(matrix_directory) do |filename|
  require File.expand_path("#{matrix_directory}/#{filename}") if filename.split(/\./).last == "rb"
end
