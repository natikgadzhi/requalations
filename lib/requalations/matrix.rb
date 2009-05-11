module Requalations
  
  # Requalations matrix module
  # Defines additional matrix methods and operations
  #
  module Matrix
    
    # Attribut reareds for p, l and u matrices in LPU decomposition
    attr_reader :l, :u, :p, :c
    
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
    
    # Retrieves LU decomposition matrices for the matrix. 
    # 
    def lu
      
      # Check, if the matrix is singular.
      raise StandardError.new("Equalation matrix can't be singular") if self.singular?
      
      # We will use the matrix size in a plenty of places here, so 
      # we want to create a shorhand accessor. 
      # We want to iterate through the matrix elements, which are started from index 0, not 1, so
      # we need to exclude 1 from elements count not to exceed matrix boundaries.
      n = self.column_size
      
      # p matrix — matrix.identity by default. 
      @p = ::Matrix.identity(n)
      
      # C matrix will contain l + u - identity
      @c = self.clone
      
      # Search for pivot elements
      # For that, we need to iterate through the columns
      
      # Iterate throught columns
      for column_index in 0...n do 
        # create a shorthand for current column
        column = @c.column(column_index)
        
        # pass 0 to pivot value and index
        pivot_value = 0.0
        # index 0 would be a valid index, so we set it to -1 to know, if we'll find a valid pivot
        pivot_index = -1
        
        # get pivot value and index from the column
        pivot_value, pivot_index = column.slice(column_index...n).absolute_max_value_and_index
        
        # We've retrieved pivot position in the column slice! 
        # So we need to add slice prefix, that is column_index to the pivot_index
        pivot_index += column_index 
        # puts " -- in the column #{column}: "
        # puts "pivot: #{pivot_value} at #{column_index}:#{pivot_index}"
        # puts "but actual element there is #{column[pivot_index]} <br>"
        
        # Swap column_index and pivotal_index rows in the identity matrix
        # by this we're gonna get premutation matrix
        # And in c matrixm, which will be our decomposition matrix 
        @c.swap_rows!(pivot_index, column_index)
        @p.swap_rows!(pivot_index, column_index)

        # Recalculate elements of c
        for j in (column_index + 1)...n do
          @c[j, column_index] = @c[j, column_index] / @c[column_index, column_index]
          for k in ( column_index + 1)...n do
            @c[j,k] = @c[j,k] - @c[j,column_index] * @c[column_index,k]
          end
        end
        
      end
      
      # After all the calculations, we have c matrix with L + U - E  
      # c = L + U - E And we know, that L is lower-triangular with 1 in the diagonal, so:
      @l = ::Matrix.identity( n )
      for i in 0...n do
        for j in 0...i
          @l[i,j] = @c[i,j]
        end
      end
      
      @u = @c - @l + ::Matrix.identity( n )
      
      [@l, @u, @p]
    end # END lu 
    
    
    # Retrieves premutation matrix as a vector 
    # 
    def p_vector
      if @p_vector.nil?
        @p_vector = []
        for i in 0...@p.column_size do
          for j in 0...@p.column_size do
            @p_vector[j] = i unless @p[i,j].eql?(0)
          end
        end
        @p_vector = ::Vector.elements(@p_vector)
      end
      @p_vector
    end # end p_vector
    
    
    ## Private instance methods
    ## --------------------------------------------------------------------------------
    private
    
    # Sets row to supplied vector
    #
    def set_row( row_index, vector )
      @rows[row_index] = vector.to_a
    end

  end
end

# If Matrix is already initialized, include Requalations::Matrix into the original one
Matrix.send( :include, ::Requalations::Matrix ) if defined?( Matrix )
Matrix.send( :include, LUSolve) if defined?( Matrix )