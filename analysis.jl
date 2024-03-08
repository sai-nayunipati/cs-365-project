#=
# Install the necessary dependencies.
using Pkg
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("GLM")
Pkg.add("Plots")
Pkg.add("StatsPlots")
=#

using CSV
using DataFrames
using GLM
using Plots
using StatsPlots

# Generate the dataframe
df = CSV.read("realtor-data.csv", DataFrame)

# Process the dataframe
function df_filter(row)
  if ismissing(row.city) || ismissing(row.state) || ismissing(row.bed) || ismissing(row.bath) || ismissing(row.house_size)
    return false
  end
  row.city == "Boston" && row.state == "Massachusetts" && row.bed <= 3 && row.bath <= 3 && row.house_size <= 2000 && row.price <= 5000000
end

filter!(df_filter, df)
df = unique(df)

# Plot the data
p1 = @df df boxplot(:bed, :price, group=:bed, xlabel="Bedroom", ylabel="Price")
p2 = @df df boxplot(:bath, :price, group=:bath, xlabel="Bathroom", ylabel="Price")
p3 = scatter(df.house_size, df.price, markersize=0.5, xlabel="House Size", ylabel="Price", alpha=0.3)
p = plot(p1, p2, p3, layout=(3, 1), legend=false)

display(p)

# Generate linear regression model.
fm = @formula(price ~ bed + bath + house_size)
model = lm(fm, df)

println("Script terminated.")