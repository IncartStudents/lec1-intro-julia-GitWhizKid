# Выболнить большую часть заданий ниже - привести примеры кода под каждым комментарием


#===========================================================================================
1. Переменные и константы, области видимости, cистема типов:
приведение к типам,
конкретные и абстрактные типы,
множественная диспетчеризация,
=#

# Что происходит с глобальной константой PI, о чем предупреждает интерпретатор?
const PI = 3.14159
PI = 3.14 # WARNING: redefinition of constant Main.PI. This may fail, cause incorrect answers, or produce other errors.

# Что происходит с типами глобальных переменных ниже, какого типа `c` и почему?
a = 1     # a - Int
b = 2.0   # b - Float64
c = a + b # c - Float64, так как происходит приведение к типу Float64 (натуральные числа входят в вещественные)

# Что теперь произошло с переменной а? Как происходит биндинг имен в Julia?
a = "foo" # Теперь a - это строка (string), изменяем биндинг имени на новый объект

# Что происходит с глобальной переменной g и почему? Чем ограничен биндинг имен в Julia?
g::Int = 1 # Объявили переменную с конкретным типом, нельзя присвоить значение другого типа
g = "hi" # MethodError: Cannot `convert` an object of type String to an object of type Int64

function greet()
    g = "hello" # Создание локальной переменной, имеет приоритет над глобальной
    println(g)
end
greet() # Вывод: hello

# Чем отличаются присвоение значений новому имени - и мутация значений?
v = [1,2,3]
z = v        # z теперь ссылается на тот же массив, что и v
v[1] = 3     # Мутация: изменяем первый элемент v
v = "hello"  # Присвоение нового значения v
z            # Вывод: [3, 2, 3]

# Написать тип, параметризованный другим типом
struct Box{T}
    value::T
end

#=
Написать функцию для двух аругментов, не указывая их тип,
и вторую функцию от двух аргментов с конкретными типами,
дать пример запуска
=#
function add1(x, y)
    return x + y
end

function add2(x::Int, y::Int)
    return x + y
end

println(add1(1, 2))   
println(add2(1, 2))

#=
Абстрактный тип - ключевое слово? – abstract type
Примитивный тип - ключевое слово? – primitive type
Композитный тип - ключевое слово? – struct
=#

#=
Написать один абстрактный тип и два его подтипа (1 и 2)
Написать функцию над абстрактным типом, и функцию над её подтипом-1
Выполнить функции над объектами подтипов 1 и 2 и объяснить результат
(функция выводит произвольный текст в консоль)
=#
abstract type Tree end

struct Palm <: Tree
    diametr::Float16
end

struct Willow <: Tree
    highth::Float16
end

function get_tree_hight(tree::Tree)
    println("Highth of the $(tree) equals 5.0 m.")
end

function get_tree_hight(willow::Willow)
    println("Highth of the $(willow) equals $(willow.highth) m.")
end

willow = Willow(2.0)
palm = Palm(1.2)

get_tree_hight(willow) # Highth of the Willow(Float16(2.0)) equals 2.0 m.
get_tree_hight(palm)   # Highth of the Palm(Float16(1.2)) equals 5.0 m.

#===========================================================================================
2. Функции:
лямбды и обычные функции,
переменное количество аргументов,
именованные аргументы со значениями по умолчанию,
кортежи
=#

# Пример обычной функции
function add(x, y)
    return x + y
end

# Пример лямбда-функции (аннонимной функции)
add_lambda = (x, y) -> x + y

# Пример функции с переменным количеством аргументов
function sum_all(args...)
    return sum(args)
end

# Пример функции с именованными аргументами
function greet(name; greeting="Hello")
    println("$greeting, $name!")
end

# Функции с переменным кол-вом именованных аргументов
function print_args(; kwargs...)
    for (key, value) in kwargs
        println("$key: $value")
    end
end

#=
Передать кортеж в функцию, которая принимает на вход несколько аргументов.
Присвоить кортеж результату функции, которая возвращает несколько аргументов.
Использовать splatting - деструктуризацию кортежа в набор аргументов.
=#

function tuple_func_sum(a, b, c)
    return a + b + c
end

t = (1,2,3)
println(tuple_func_sum(t...)) # 6

#===========================================================================================
3. loop fusion, broadcast, filter, map, reduce, list comprehension
=#

#=
Перемножить все элементы массива
- через loop fusion и
- с помощью reduce
=#

arr = [1, 2, 3, 4]
res = 1
for i in 1:lastindex(arr)
    res *= arr[i] 
end

println(res) #24
println(reduce(*, arr))

#=
Написать функцию от одного аргумента и запустить ее по всем элементам массива
с помощью точки (broadcast)
c помощью map
c помощью list comprehension
указать, чем это лучше явного цикла?
=#

function cube_x(x)
    return x^3
end

# Это более читаемо и часто быстрее выполняется компилятором
arr = [1, 2, 3, 4, 5]
println(cube_x.(arr))                 # с помощью точки (broadcast)
println(map(cube_x, arr))             # c помощью map
println([cube_x(x) for x in arr])     # c помощью list comprehension

# Перемножить вектор-строку [1 2 3] на вектор-столбец [10,20,30] и объяснить результат
A = [1 2 3]
B = [10, 20, 30]
println(A * B) # 140 = 1 * 10 + 2 * 20 + 3 * 30 

# В одну строку выбрать из массива [1, -2, 2, 3, 4, -5, 0] только четные и положительные числа
res = filter(x -> x % 2 == 0 && x > 0, [1, -2, 2, 3, 4, -5, 0])
println(res) # [2, 4] 

# Объяснить следующий код обработки массива names - что за number мы в итоге определили?
using Random
Random.seed!(123)
names = [rand('A':'Z') * '_' * rand('0':'9') * rand([".csv", ".bin"]) for _ in 1:100]
# ---
same_names = unique(map(y -> split(y, ".")[1], filter(x -> startswith(x, "A"), names)))
numbers = parse.(Int, map(x -> split(x, "_")[end], same_names))
numbers_sorted = sort(numbers)
number = findfirst(n -> !(n in numbers_sorted), 0:9) # определяем первую цифру от 0 до 9, которой нет в массиве numbers_sorted

# Упростить этот код обработки:
numbers = sort(unique(parse.(Int, map(x -> split(split(x, ".")[1], "_")[end], filter(x -> startswith(x, "A"), names)))))
number = findfirst(n -> !(n in numbers_sorted), 0:9)

#===========================================================================================
4. Свой тип данных на общих интерфейсах
=#

#=
написать свой тип ленивого массива, каждый элемент которого
вычисляется при взятии индекса (getindex) по формуле (index - 1)^2
=#

struct MyArray end

function Base.getindex(arr::MyArray, index::Int)
    return (index - 1)^2 
end

my_array = MyArray()
println(my_array[3])

#=
Написать два типа объектов команд, унаследованных от AbstractCommand,
которые применяются к массиву:
`SortCmd()` - сортирует исходный массив
`ChangeAtCmd(i, val)` - меняет элемент на позиции i на значение val
Каждая команда имеет конструктор и реализацию метода apply!
=#

abstract type AbstractCommand end
apply!(cmd::AbstractCommand, target::Vector) = error("Not implemented for type $(typeof(cmd))")

struct SortCmd <: AbstractCommand
    function apply!(cmd::SortCmd, target::Vector)
        sort!(target)  # Сортируем массив на месте
    end
end

struct ChangeAtCmd <: AbstractCommand
    i::Int
    val::Int
    function apply!(cmd::ChangeAtCmd, target::Vector)
        target[cmd.i] = cmd.val
    end
end

# Аналогичные команды, но без наследования и в виде замыканий (лямбда-функций)
sort_cmd_lambda = () -> sort!(arr)
change_cmd_lambda = (i, val) -> (arr[i] = val)

#===========================================================================================
5. Тесты: как проверять функции?
=#

# Написать тест для функции
using Test

function add(x, y)
    return x + y
end

@test add(1, 2) == 3  # Test Passed
@test add(-1, 1) == 0 # Test Passed

#===========================================================================================
6. Дебаг: как отладить функцию по шагам?
=#

#=
Отладить функцию по шагам с помощью макроса @enter и точек останова
=#

function devision_zero(x)
    return x / 0
end

@enter devision_zero(10)

devision_zero(10) # Inf

#===========================================================================================
7. Профилировщик: как оценить производительность функции?
=#

#=
Оценить производительность функции с помощью макроса @profview,
и добавить в этот репозиторий файл со скриншотом flamechart'а
=#

function generate_data(len)
    vec1 = Any[]
    for k = 1:len
        r = randn(1,1)
        append!(vec1, r)
    end
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end

# @time generate_data(1_000_000); # 2.204234 seconds (7.00 M allocations: 192.889 MiB, 15.75% gc time
@profview generate_data(1_000_000)

# Переписать функцию выше так, чтобы она выполнялась быстрее:

function generate_data_optimized(len)
    vec1 = randn(len)
    vec2 = sort(vec1)
    vec3 = vec2 .^ 3 .- (sum(vec2) / len)
    return vec3
end

@time generate_data_optimized(1_000_000) # 1.463921 seconds (18 allocations: 26.722 MiB, 94.75% gc time)

#===========================================================================================
8. Отличия от матлаба: приращение массива и предварительная аллокация?
=#

#=
Написать функцию определения первой разности, которая принимает и возвращает массив
и для каждой точки входного (x) и выходного (y) выходного массива вычисляет:
y[i] = x[i] - x[i-1]
=#

function first_diff(x::Array)
    y::Array = [](sizeof(x) - 1)
    for i in 2:lastindex(x)
        y[i] = x[i] - x[i-1]
    end
    return y
end


#=
Аналогичная функция, которая отличается тем, что внутри себя не аллоцирует новый массив y,
а принимает его первым аргументом, сам массив аллоцируется до вызова функции
=#

function first_diff(y::Array, x::Array)
    for i in 2:lastindex(x)
        y[i] = x[i] - x[i-1]
    end
end

#=
Написать код, который добавляет элементы в конец массива, в начало массива,
в середину массива
=#
function insert_start(arr, el)
    push!(arr, el)
    arr = [arr[end]; arr[1:end-1]]
    return arr
end

arr = []
push!(arr, 1)  # В конец
arr =insert_start(arr, 0)  # В начало
insert!(arr, 2, 1)  # В середину
println(arr)


#===========================================================================================
9. Модули и функции: как оборачивать функции внутрь модуля, как их экспортировать
и пользоваться вне модуля?
=#


#=
Написать модуль с двумя функциями,
экспортировать одну из них,
воспользоваться обеими функциями вне модуля
=#
module Foo

    export greet

    function greet(name::String)
        println("Hello, $(name)!")
    end
    function farewell(name::String)
        println("Goodbye, $(name)!")
    end
end

using .Foo

Foo.greet("Alice") # Hello, Alice!
Foo.farewell("Alice") # Goodbye, Alice!

import .Foo
Foo.greet("Alice") # Hello, Alice!
Foo.farewell("Alice")

#===========================================================================================
10. Зависимости, окружение и пакеты
=#

# Что такое environment, как задать его, как его поменять во время работы?
using Pkg
Pkg.activate("my_environment")

# Что такое пакет (package), как добавить новый пакет?
Pkg.add("DataFrames")

# Как начать разрабатывать чужой пакет?
Pkg.develop("https://github.com/username/repo.git")

#=
Как создать свой пакет?
(необязательно, эксперименты с PkgTemplates проводим вне этого репозитория)
=#
using PkgTemplates
t = PkgTemplates.PkgTemplate("MyPackage")
t.generate()


#===========================================================================================
11. Сохранение переменных в файл и чтение из файла.
Подключить пакеты JLD2, CSV.
=#
using JLD2, CSV

# Сохранить и загрузить произвольные обхекты в JLD2, сравнить их
data = Dict("a" => 1, "b" => [1, 2, 3])
@save "data.jld2" data
@load "data.jld2" data_loaded
println(data_loaded)

# Сохранить и загрузить табличные объекты (массивы) в CSV, сравнить их
table_data = DataFrame(A = 1:3, B = ["x", "y", "z"])
CSV.write("table.csv", table_data)
loaded_table = CSV.File("table.csv") |> DataFrame
println(loaded_table) 

#===========================================================================================
12. Аргументы запуска Julia
=#

#=
Как задать окружение при запуске?
=#
# julia --project=my_environment

#=
Как задать скрипт, который будет выполняться при запуске:
а) из файла .jl
б) из текста команды? (см. флаг -e)
=#
# julia script.jl
# julia -e 'println("Hello from command line")'

#=
После выполнения задания Boids запустить julia из командной строки,
передав в виде аргумента имя gif-файла для сохранения анимации
=#
# julia boids.jl output.gif
