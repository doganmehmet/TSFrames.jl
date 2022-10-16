# Constants
YEAR = 2022
MONTH = 1
DAYS = 15

dates = Date(YEAR, MONTH, 1):Day(1):Date(YEAR, MONTH, DAYS)
ts = TS(1:DAYS, dates)

@test Tables.istable(ts)

# testing Tables.rows
@test Tables.rowaccess(ts)
@test Tables.rows(ts).Index == dates
@test Tables.rows(ts).x1 == 1:DAYS

# testing Tables.columns
@test Tables.columns(ts).Index == dates
@test Tables.columns(ts).x1 == 1:DAYS

# testing Tables.rowtable
rowTable = Tables.rowtable(ts)
@test typeof(rowTable) == Vector{NamedTuple{(:Index, :x1), Tuple{Date, Int64}}}
@test first(rowTable) == (Index=Date(YEAR, MONTH, 1), x1=1)

# testing Tables.columntable
columnTable = Tables.columntable(ts)
@test typeof(columnTable) == NamedTuple{(:Index, :x1), Tuple{Vector{Date}, Vector{Int64}}}
@test columnTable[:Index] == dates
@test columnTable[:x1] == 1:DAYS

# testing Tables.namedtupleiterator
namedtuple = first(Tables.namedtupleiterator(ts))
@test namedtuple == first(Tables.rowtable(ts))

# testing columnindex
@test Tables.columnindex(ts, :Index) == 1
@test Tables.columnindex(ts, "Index") == 1
@test Tables.columnindex(ts, :x1) == 2
@test Tables.columnindex(ts, "x1") == 2

# testing Tables.schema
@test Tables.schema(ts).names == (:Index, :x1)
@test Tables.schema(ts).types == (Date, Int64)

# testing Tables.materializer
@test Tables.materializer(ts) == TS

# testing Tables.getcolumn
indexCol = Tables.getcolumn(ts, :Index)
x1Col = Tables.getcolumn(ts, :x1)
@test indexCol == dates
@test x1Col == 1:DAYS
@test indexCol == Tables.getcolumn(ts, 1)
@test x1Col == Tables.getcolumn(ts, 2)
