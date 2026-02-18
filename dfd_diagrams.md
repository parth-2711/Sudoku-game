# FarmLink – Data Flow Diagrams (DFD)

---

## 📌 Level 0 DFD — Context Diagram

> Shows the entire FarmLink system as a single process with all external entities.

```mermaid
flowchart LR
    Farmer(["👨‍🌾 Farmer"])
    Consumer(["🛒 Consumer"])
    Delivery(["🚚 Delivery Partner"])
    Firebase[("🔥 Firebase\nFirestore")]

    Farmer -- "Product Info, Profile, Farm Address" --> System["⚙️ FarmLink System"]
    Consumer -- "Browse, Order, Payment" --> System
    Delivery -- "Accept Delivery, Update Status" --> System
    System -- "Order Notifications, Earnings" --> Farmer
    System -- "Order Confirmation, Tracking" --> Consumer
    System -- "Pickup & Drop Details, Earnings" --> Delivery
    System <--> Firebase
```

---

## 📌 Level 1 DFD — Main Processes

> Breaks the system into major functional processes.

```mermaid
flowchart TD
    Farmer(["👨‍🌾 Farmer"])
    Consumer(["🛒 Consumer"])
    Delivery(["🚚 Delivery Partner"])
    DB[("🔥 Firestore DB")]

    Farmer --> P1["1.0\nFarmer Registration\n& Profile Mgmt"]
    Farmer --> P2["2.0\nProduct\nManagement"]
    Consumer --> P3["3.0\nConsumer\nRegistration & Login"]
    Consumer --> P4["4.0\nBrowse Products\n& Cart"]
    Consumer --> P5["5.0\nOrder Placement\n& Checkout"]
    Delivery --> P6["6.0\nDelivery Partner\nRegistration & Login"]
    Delivery --> P7["7.0\nOrder Acceptance\n& Delivery"]

    P1 -- "Store Profile & Farm Address" --> DB
    P2 -- "Store/Update Products" --> DB
    P3 -- "Store Consumer Profile" --> DB
    P4 -- "Read Products" --> DB
    P5 -- "Create Order (with Pickup Address)" --> DB
    P6 -- "Store Partner Profile" --> DB
    P7 -- "Update Order Status" --> DB

    DB -- "Order Notification" --> Farmer
    DB -- "Order Confirmation" --> Consumer
    DB -- "Available Orders" --> Delivery
```

---

## 📌 Level 2 DFD — Detailed Sub-Processes

### 2A: Product Management (Process 2.0)

```mermaid
flowchart TD
    Farmer(["👨‍🌾 Farmer"])
    PDB[("🔥 Products\nCollection")]
    FarmerApp["Farmer App"]

    Farmer --> P2_1["2.1\nAdd New Product\n(Name, Price, Unit, Image)"]
    Farmer --> P2_2["2.2\nEdit / Update\nProduct"]
    Farmer --> P2_3["2.3\nDelete Product"]
    Farmer --> P2_4["2.4\nView My Products\n& Stock"]

    P2_1 -- "Write Product Doc" --> PDB
    P2_2 -- "Update Product Doc" --> PDB
    P2_3 -- "Delete Product Doc" --> PDB
    PDB -- "Read Products" --> P2_4
    P2_4 --> FarmerApp
```

---

### 2B: Order Placement (Process 5.0)

```mermaid
flowchart TD
    Consumer(["🛒 Consumer"])
    UDB[("🔥 Users\nCollection")]
    ODB[("🔥 Orders\nCollection")]

    Consumer --> P5_1["5.1\nSelect Products\n& Add to Cart"]
    P5_1 --> P5_2["5.2\nEnter Delivery\nDetails (Address, Phone)"]
    P5_2 --> P5_3["5.3\nFetch Farmer Profile\n(Farm Address & Phone)"]
    P5_3 -- "Read farmAddress & phone" --> UDB
    UDB -- "Farmer Address & Phone" --> P5_3
    P5_3 --> P5_4["5.4\nCreate Order\n(pickupAddress, farmerPhone,\ndropAddress, items, fees)"]
    P5_4 -- "Write Order Doc" --> ODB
    ODB -- "Order Confirmation" --> Consumer
```

---

### 2C: Order Delivery (Process 7.0)

```mermaid
flowchart TD
    Delivery(["🚚 Delivery Partner"])
    ODB[("🔥 Orders\nCollection")]

    Delivery --> P7_1["7.1\nView Available Orders\n(status = 'ready')"]
    P7_1 -- "Query Orders" --> ODB
    ODB -- "Order List" --> P7_1
    P7_1 --> P7_2["7.2\nView Order Details\n(Pickup Address, Farmer Phone,\nDrop Address, Consumer Phone)"]
    P7_2 --> P7_3["7.3\nAccept Order\n(status → 'accepted')"]
    P7_3 -- "Update Status" --> ODB
    P7_3 --> P7_4["7.4\nPickup from Farm\n(Call Farmer if needed)"]
    P7_4 --> P7_5["7.5\nDeliver to Consumer\n(status → 'delivered')"]
    P7_5 -- "Update Status" --> ODB
    ODB -- "Delivery Confirmation" --> Delivery
```

---

## 📊 Data Stores Summary

| Data Store | Collection | Key Fields |
|---|---|---|
| Users | `users` | userId, role, name, email, phone, farmName, farmAddress |
| Products | `products` | productId, farmerId, name, price, unit, stock |
| Orders | `orders` | orderId, consumerId, farmerId, items, pickupAddress, farmerPhone, dropAddress, status |
| Delivery Partners | `users` (role=delivery) | userId, name, phone, vehicleType |
