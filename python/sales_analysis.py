import pandas as pd

# Customer sales data
sales = {
    "Customer": ["John", "Mary", "Kate", "John", "Mary"],
    "Amount": [500, 800, 300, 200, 400]
}

# Create DataFrame
df = pd.DataFrame(sales)

# Calculate total spent by customer
customer_totals = df.groupby("Customer")["Amount"].sum()

print("Customer Spending Summary:")
print(customer_totals)
