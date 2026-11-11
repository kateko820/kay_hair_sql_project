import pandas as pd

customers = {
    "Customer": ["Ayanda", "Lerato", "Thabo", "Naledi", "Sipho"],
    "Purchases": [12, 4, 8, 2, 15]
}

df = pd.DataFrame(customers)

def classify_customer(purchases):
    if purchases >= 10:
        return "Frequent Buyer"
    elif purchases >= 5:
        return "Returning Customer"
    else:
        return "New Customer"

df["Customer_Type"] = df["Purchases"].apply(classify_customer)

print(df)
