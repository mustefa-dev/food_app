# Food Delivery App API Specification

## Base URL
```
https://api.foodapp.com/v1
```

## Authentication
All authenticated endpoints require an Authorization header:
```
Authorization: Bearer <jwt_token>
```

## Common Response Structure
```json
{
  "success": true,
  "data": {},
  "message": "Success message",
  "timestamp": "2025-09-21T10:30:00Z"
}
```

## Error Response Structure
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description",
    "details": {}
  },
  "timestamp": "2025-09-21T10:30:00Z"
}
```

---

## 1. Authentication Endpoints

### 1.1 Register User
**POST** `/auth/register`

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "password": "securePassword123",
  "confirmPassword": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "avatar": null,
      "isVerified": false,
      "createdAt": "2025-09-21T10:30:00Z"
    },
    "token": "jwt_token_here"
  },
  "message": "Registration successful"
}
```

### 1.2 Login
**POST** `/auth/login`

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_123",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "avatar": "https://api.foodapp.com/uploads/avatar_123.jpg",
      "isVerified": true,
      "addresses": [
        {
          "id": "addr_1",
          "type": "home",
          "street": "123 Main St",
          "city": "New York",
          "state": "NY",
          "zipCode": "10001",
          "isDefault": true
        }
      ]
    },
    "token": "jwt_token_here"
  },
  "message": "Login successful"
}
```

### 1.3 Refresh Token
**POST** `/auth/refresh`

**Request Body:**
```json
{
  "refreshToken": "refresh_token_here"
}
```

### 1.4 Logout
**POST** `/auth/logout`
*Requires Authentication*

---

## 2. User Profile Endpoints

### 2.1 Get User Profile
**GET** `/user/profile`
*Requires Authentication*

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "avatar": "https://api.foodapp.com/uploads/avatar_123.jpg",
    "isVerified": true,
    "loyaltyPoints": 250,
    "totalOrders": 15,
    "memberSince": "2024-01-15T10:30:00Z",
    "preferences": {
      "dietary": ["vegetarian"],
      "notifications": {
        "orderUpdates": true,
        "promotions": false,
        "recommendations": true
      }
    }
  }
}
```

### 2.2 Update User Profile
**PUT** `/user/profile`
*Requires Authentication*

**Request Body:**
```json
{
  "name": "John Smith",
  "phone": "+1234567891",
  "preferences": {
    "dietary": ["vegetarian", "gluten-free"],
    "notifications": {
      "orderUpdates": true,
      "promotions": true,
      "recommendations": true
    }
  }
}
```

### 2.3 Upload Avatar
**POST** `/user/avatar`
*Requires Authentication*
*Content-Type: multipart/form-data*

**Request:**
```
file: [image file]
```

---

## 3. Address Management

### 3.1 Get User Addresses
**GET** `/user/addresses`
*Requires Authentication*

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "addr_1",
      "type": "home",
      "label": "Home",
      "street": "123 Main St",
      "apartment": "Apt 4B",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001",
      "latitude": 40.7128,
      "longitude": -74.0060,
      "isDefault": true,
      "deliveryInstructions": "Ring doorbell"
    }
  ]
}
```

### 3.2 Add Address
**POST** `/user/addresses`
*Requires Authentication*

**Request Body:**
```json
{
  "type": "work",
  "label": "Office",
  "street": "456 Business Ave",
  "apartment": "Suite 200",
  "city": "New York",
  "state": "NY",
  "zipCode": "10002",
  "latitude": 40.7589,
  "longitude": -73.9851,
  "isDefault": false,
  "deliveryInstructions": "Call upon arrival"
}
```

### 3.3 Update Address
**PUT** `/user/addresses/{addressId}`
*Requires Authentication*

### 3.4 Delete Address
**DELETE** `/user/addresses/{addressId}`
*Requires Authentication*

---

## 4. Restaurant Endpoints

### 4.1 Get Nearby Restaurants
**GET** `/restaurants`

**Query Parameters:**
- `latitude` (required): User's latitude
- `longitude` (required): User's longitude
- `radius`: Search radius in km (default: 10)
- `category`: Restaurant category filter
- `minRating`: Minimum rating filter
- `sortBy`: `distance`, `rating`, `delivery_time`, `popularity`
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)

**Response:**
```json
{
  "success": true,
  "data": {
    "restaurants": [
      {
        "id": "rest_1",
        "name": "Pizza Palace",
        "slug": "pizza-palace",
        "description": "Authentic Italian pizzas made fresh daily",
        "image": "https://api.foodapp.com/uploads/restaurant_1.jpg",
        "coverImage": "https://api.foodapp.com/uploads/restaurant_1_cover.jpg",
        "logo": "https://api.foodapp.com/uploads/restaurant_1_logo.jpg",
        "rating": 4.5,
        "reviewCount": 1250,
        "priceRange": "$$",
        "cuisineTypes": ["Italian", "Pizza"],
        "deliveryTime": {
          "min": 25,
          "max": 35
        },
        "deliveryFee": 2.99,
        "minimumOrder": 15.00,
        "isOpen": true,
        "distance": 1.2,
        "address": {
          "street": "789 Food St",
          "city": "New York",
          "state": "NY",
          "zipCode": "10003"
        },
        "features": ["contactless_delivery", "group_ordering"],
        "promotions": [
          {
            "id": "promo_1",
            "title": "20% off your first order",
            "description": "New customers only",
            "type": "percentage",
            "value": 20,
            "minimumOrder": 25.00
          }
        ]
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "totalPages": 3
    }
  }
}
```

### 4.2 Get Restaurant Details
**GET** `/restaurants/{restaurantId}`

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "rest_1",
    "name": "Pizza Palace",
    "slug": "pizza-palace",
    "description": "Authentic Italian pizzas made fresh daily",
    "image": "https://api.foodapp.com/uploads/restaurant_1.jpg",
    "coverImage": "https://api.foodapp.com/uploads/restaurant_1_cover.jpg",
    "gallery": [
      "https://api.foodapp.com/uploads/restaurant_1_1.jpg",
      "https://api.foodapp.com/uploads/restaurant_1_2.jpg"
    ],
    "rating": 4.5,
    "reviewCount": 1250,
    "priceRange": "$$",
    "cuisineTypes": ["Italian", "Pizza"],
    "deliveryTime": {
      "min": 25,
      "max": 35
    },
    "deliveryFee": 2.99,
    "minimumOrder": 15.00,
    "isOpen": true,
    "openingHours": {
      "monday": {"open": "11:00", "close": "23:00"},
      "tuesday": {"open": "11:00", "close": "23:00"},
      "wednesday": {"open": "11:00", "close": "23:00"},
      "thursday": {"open": "11:00", "close": "23:00"},
      "friday": {"open": "11:00", "close": "01:00"},
      "saturday": {"open": "11:00", "close": "01:00"},
      "sunday": {"open": "12:00", "close": "22:00"}
    },
    "contact": {
      "phone": "+1234567890",
      "email": "info@pizzapalace.com"
    },
    "address": {
      "street": "789 Food St",
      "city": "New York",
      "state": "NY",
      "zipCode": "10003",
      "latitude": 40.7282,
      "longitude": -73.9942
    },
    "features": ["contactless_delivery", "group_ordering", "accepts_cash"],
    "tags": ["popular", "fast_delivery"]
  }
}
```

### 4.3 Get Restaurant Menu
**GET** `/restaurants/{restaurantId}/menu`

**Response:**
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "id": "cat_1",
        "name": "Appetizers",
        "description": "Start your meal right",
        "displayOrder": 1,
        "items": [
          {
            "id": "item_1",
            "name": "Garlic Bread",
            "description": "Fresh baked bread with garlic butter and herbs",
            "price": 6.99,
            "image": "https://api.foodapp.com/uploads/item_1.jpg",
            "isVegetarian": true,
            "isVegan": false,
            "isGlutenFree": false,
            "calories": 180,
            "preparationTime": 10,
            "isAvailable": true,
            "tags": ["popular", "starter"],
            "allergens": ["gluten", "dairy"],
            "extras": [
              {
                "id": "extra_1",
                "name": "Extra Cheese",
                "price": 1.50,
                "isRequired": false
              },
              {
                "id": "extra_2",
                "name": "Size",
                "options": [
                  {"id": "size_small", "name": "Small", "price": 0},
                  {"id": "size_large", "name": "Large", "price": 2.00}
                ],
                "isRequired": true,
                "maxSelections": 1
              }
            ]
          }
        ]
      }
    ]
  }
}
```

---

## 5. Cart Management

### 5.1 Get Cart
**GET** `/cart`
*Requires Authentication*

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "cart_123",
    "restaurantId": "rest_1",
    "restaurantName": "Pizza Palace",
    "items": [
      {
        "id": "cart_item_1",
        "dishId": "item_1",
        "name": "Margherita Pizza",
        "price": 14.99,
        "quantity": 2,
        "image": "https://api.foodapp.com/uploads/item_1.jpg",
        "extras": [
          {
            "id": "extra_1",
            "name": "Extra Cheese",
            "price": 1.50
          }
        ],
        "specialInstructions": "Extra crispy",
        "itemTotal": 32.98
      }
    ],
    "subtotal": 32.98,
    "deliveryFee": 2.99,
    "serviceFee": 1.50,
    "tax": 2.89,
    "discount": 0,
    "total": 40.36,
    "itemCount": 2,
    "appliedPromo": null
  }
}
```

### 5.2 Add Item to Cart
**POST** `/cart/items`
*Requires Authentication*

**Request Body:**
```json
{
  "restaurantId": "rest_1",
  "dishId": "item_1",
  "quantity": 2,
  "extras": [
    {
      "id": "extra_1",
      "optionId": "size_large"
    }
  ],
  "specialInstructions": "Extra crispy"
}
```

### 5.3 Update Cart Item
**PUT** `/cart/items/{cartItemId}`
*Requires Authentication*

**Request Body:**
```json
{
  "quantity": 3,
  "extras": [
    {
      "id": "extra_1",
      "optionId": "size_large"
    }
  ],
  "specialInstructions": "Well done"
}
```

### 5.4 Remove Cart Item
**DELETE** `/cart/items/{cartItemId}`
*Requires Authentication*

### 5.5 Clear Cart
**DELETE** `/cart`
*Requires Authentication*

### 5.6 Apply Promo Code
**POST** `/cart/promo`
*Requires Authentication*

**Request Body:**
```json
{
  "promoCode": "SAVE20"
}
```

---

## 6. Order Management

### 6.1 Create Order
**POST** `/orders`
*Requires Authentication*

**Request Body:**
```json
{
  "deliveryAddress": {
    "id": "addr_1"
  },
  "paymentMethod": {
    "type": "card",
    "cardId": "card_123"
  },
  "deliveryInstructions": "Leave at door",
  "promoCode": "SAVE20",
  "scheduledDelivery": null,
  "tip": 5.00
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "order_123",
    "orderNumber": "ORD-20250921-001",
    "status": "confirmed",
    "restaurant": {
      "id": "rest_1",
      "name": "Pizza Palace",
      "phone": "+1234567890",
      "image": "https://api.foodapp.com/uploads/restaurant_1.jpg"
    },
    "items": [
      {
        "id": "order_item_1",
        "name": "Margherita Pizza",
        "quantity": 2,
        "price": 14.99,
        "extras": ["Extra Cheese"],
        "specialInstructions": "Extra crispy",
        "total": 32.98
      }
    ],
    "pricing": {
      "subtotal": 32.98,
      "deliveryFee": 2.99,
      "serviceFee": 1.50,
      "tax": 2.89,
      "tip": 5.00,
      "discount": 6.60,
      "total": 38.76
    },
    "deliveryAddress": {
      "street": "123 Main St",
      "apartment": "Apt 4B",
      "city": "New York",
      "state": "NY",
      "zipCode": "10001"
    },
    "estimatedDeliveryTime": "2025-09-21T11:30:00Z",
    "placedAt": "2025-09-21T10:30:00Z",
    "paymentStatus": "paid"
  }
}
```

### 6.2 Get Order History
**GET** `/orders`
*Requires Authentication*

**Query Parameters:**
- `status`: Filter by order status
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 10)

**Response:**
```json
{
  "success": true,
  "data": {
    "orders": [
      {
        "id": "order_123",
        "orderNumber": "ORD-20250921-001",
        "status": "delivered",
        "restaurant": {
          "id": "rest_1", 
          "name": "Pizza Palace",
          "image": "https://api.foodapp.com/uploads/restaurant_1.jpg"
        },
        "itemCount": 2,
        "total": 38.76,
        "placedAt": "2025-09-21T10:30:00Z",
        "deliveredAt": "2025-09-21T11:25:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 25,
      "totalPages": 3
    }
  }
}
```

### 6.3 Get Order Details
**GET** `/orders/{orderId}`
*Requires Authentication*

### 6.4 Track Order
**GET** `/orders/{orderId}/tracking`
*Requires Authentication*

**Response:**
```json
{
  "success": true,
  "data": {
    "orderId": "order_123",
    "status": "in_transit",
    "estimatedDeliveryTime": "2025-09-21T11:30:00Z",
    "driver": {
      "id": "driver_1",
      "name": "Mike Johnson",
      "phone": "+1234567891",
      "rating": 4.8,
      "vehicle": "Red Honda Civic - ABC123",
      "location": {
        "latitude": 40.7300,
        "longitude": -73.9950
      }
    },
    "timeline": [
      {
        "status": "confirmed",
        "timestamp": "2025-09-21T10:30:00Z",
        "message": "Order confirmed by restaurant"
      },
      {
        "status": "preparing",
        "timestamp": "2025-09-21T10:35:00Z",
        "message": "Restaurant is preparing your order"
      },
      {
        "status": "ready_for_pickup",
        "timestamp": "2025-09-21T10:55:00Z",
        "message": "Order is ready for pickup"
      },
      {
        "status": "picked_up",
        "timestamp": "2025-09-21T11:00:00Z",
        "message": "Driver picked up your order"
      },
      {
        "status": "in_transit",
        "timestamp": "2025-09-21T11:05:00Z",
        "message": "On the way to you"
      }
    ]
  }
}
```

### 6.5 Cancel Order
**POST** `/orders/{orderId}/cancel`
*Requires Authentication*

**Request Body:**
```json
{
  "reason": "changed_mind",
  "comment": "Ordered by mistake"
}
```

### 6.6 Rate Order
**POST** `/orders/{orderId}/rating`
*Requires Authentication*

**Request Body:**
```json
{
  "restaurantRating": 5,
  "driverRating": 4,
  "foodQuality": 5,
  "deliveryTime": 4,
  "comment": "Great food, fast delivery!",
  "wouldRecommend": true
}
```

---

## 7. Search & Discovery

### 7.1 Search
**GET** `/search`

**Query Parameters:**
- `q`: Search query
- `type`: `restaurants`, `dishes`, `all` (default: all)
- `latitude`: User's latitude
- `longitude`: User's longitude
- `filters`: JSON encoded filters object

**Response:**
```json
{
  "success": true,
  "data": {
    "restaurants": [
      {
        "id": "rest_1",
        "name": "Pizza Palace",
        "image": "https://api.foodapp.com/uploads/restaurant_1.jpg",
        "rating": 4.5,
        "deliveryTime": "25-35 min",
        "cuisineTypes": ["Italian", "Pizza"]
      }
    ],
    "dishes": [
      {
        "id": "item_1",
        "name": "Margherita Pizza",
        "price": 14.99,
        "image": "https://api.foodapp.com/uploads/item_1.jpg",
        "restaurant": {
          "id": "rest_1",
          "name": "Pizza Palace"
        }
      }
    ],
    "suggestions": ["pizza", "pasta", "italian food"]
  }
}
```

### 7.2 Get Categories
**GET** `/categories`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "cat_1",
      "name": "Pizza",
      "slug": "pizza",
      "image": "https://api.foodapp.com/uploads/category_pizza.jpg",
      "restaurantCount": 45
    },
    {
      "id": "cat_2", 
      "name": "Burger",
      "slug": "burger",
      "image": "https://api.foodapp.com/uploads/category_burger.jpg",
      "restaurantCount": 32
    }
  ]
}
```

---

## 8. Offers & Promotions

### 8.1 Get Active Offers
**GET** `/offers`
*Requires Authentication*

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "offer_1",
      "title": "20% Off First Order",
      "description": "Get 20% off your first order with code WELCOME20",
      "image": "https://api.foodapp.com/uploads/offer_1.jpg",
      "type": "percentage",
      "value": 20,
      "code": "WELCOME20",
      "minimumOrder": 25.00,
      "maxDiscount": 10.00,
      "validUntil": "2025-12-31T23:59:59Z",
      "applicableRestaurants": [],
      "isPersonalized": true,
      "usageLimit": 1,
      "usedCount": 0
    },
    {
      "id": "offer_2",
      "title": "Free Delivery Weekend",
      "description": "Free delivery on all orders this weekend",
      "image": "https://api.foodapp.com/uploads/offer_2.jpg",
      "type": "free_delivery",
      "code": "FREEDEL",
      "minimumOrder": 15.00,
      "validFrom": "2025-09-21T00:00:00Z",
      "validUntil": "2025-09-22T23:59:59Z",
      "applicableRestaurants": ["rest_1", "rest_2"]
    }
  ]
}
```

### 8.2 Validate Promo Code
**POST** `/offers/validate`
*Requires Authentication*

**Request Body:**
```json
{
  "code": "WELCOME20",
  "restaurantId": "rest_1",
  "orderTotal": 35.50
}
```

---

## 9. Loyalty Program

### 9.1 Get Loyalty Status
**GET** `/loyalty`
*Requires Authentication*

**Response:**
```json
{
  "success": true,
  "data": {
    "currentPoints": 1250,
    "tier": "gold",
    "nextTier": "platinum",
    "pointsToNextTier": 750,
    "totalEarned": 2500,
    "totalRedeemed": 1250,
    "availableRewards": [
      {
        "id": "reward_1",
        "title": "Free Delivery",
        "description": "Get free delivery on your next order",
        "pointsCost": 100,
        "type": "free_delivery",
        "validityDays": 30
      },
      {
        "id": "reward_2", 
        "title": "$5 Off",
        "description": "Get $5 off your next order",
        "pointsCost": 250,
        "type": "discount",
        "value": 5.00,
        "validityDays": 30
      }
    ],
    "tierBenefits": {
      "pointsMultiplier": 1.5,
      "freeDeliveryThreshold": 25.00,
      "exclusiveOffers": true
    }
  }
}
```

### 9.2 Redeem Reward
**POST** `/loyalty/redeem`
*Requires Authentication*

**Request Body:**
```json
{
  "rewardId": "reward_1"
}
```

---

## 10. Payment Methods

### 10.1 Get Payment Methods
**GET** `/payment/methods`
*Requires Authentication*

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "card_1",
      "type": "card",
      "brand": "visa",
      "last4": "4242",
      "expiryMonth": 12,
      "expiryYear": 2027,
      "isDefault": true,
      "nickname": "Personal Card"
    },
    {
      "id": "paypal_1",
      "type": "paypal", 
      "email": "john@example.com",
      "isDefault": false
    }
  ]
}
```

### 10.2 Add Payment Method
**POST** `/payment/methods`
*Requires Authentication*

**Request Body:**
```json
{
  "type": "card",
  "token": "payment_method_token_from_frontend",
  "isDefault": false,
  "nickname": "Work Card"
}
```

---

## 11. Notifications

### 11.1 Get Notifications
**GET** `/notifications`
*Requires Authentication*

**Query Parameters:**
- `unreadOnly`: boolean (default: false)
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)

**Response:**
```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": "notif_1",
        "type": "order_update",
        "title": "Order Delivered!",
        "message": "Your order from Pizza Palace has been delivered",
        "isRead": false,
        "createdAt": "2025-09-21T11:30:00Z",
        "data": {
          "orderId": "order_123"
        }
      },
      {
        "id": "notif_2",
        "type": "promotion",
        "title": "Special Offer",
        "message": "Get 25% off your next order at Italian Bistro",
        "isRead": true,
        "createdAt": "2025-09-20T15:00:00Z",
        "data": {
          "promoCode": "SAVE25",
          "restaurantId": "rest_5"
        }
      }
    ],
    "unreadCount": 3,
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 45,
      "totalPages": 3
    }
  }
}
```

### 11.2 Mark Notification as Read
**PUT** `/notifications/{notificationId}/read`
*Requires Authentication*

### 11.3 Mark All as Read
**PUT** `/notifications/read-all`
*Requires Authentication*

---

## 12. Support

### 12.1 Get Help Topics
**GET** `/support/topics`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "topic_1",
      "title": "Order Issues",
      "description": "Problems with your current or past orders",
      "icon": "order",
      "subcategories": [
        {
          "id": "sub_1", 
          "title": "Order not delivered",
          "description": "Your order hasn't arrived"
        },
        {
          "id": "sub_2",
          "title": "Wrong order received", 
          "description": "You received the wrong items"
        }
      ]
    }
  ]
}
```

### 12.2 Create Support Ticket
**POST** `/support/tickets`
*Requires Authentication*

**Request Body:**
```json
{
  "topicId": "topic_1",
  "subcategoryId": "sub_1",
  "orderId": "order_123",
  "subject": "Order not delivered",
  "message": "My order was supposed to arrive 30 minutes ago but hasn't been delivered yet.",
  "priority": "high"
}
```

### 12.3 Get Support Tickets
**GET** `/support/tickets`
*Requires Authentication*

---

## 13. WebSocket Events

### Connection
```
wss://api.foodapp.com/ws?token=jwt_token
```

### Order Tracking Events
```json
{
  "event": "order_status_update",
  "data": {
    "orderId": "order_123",
    "status": "preparing",
    "estimatedDeliveryTime": "2025-09-21T11:30:00Z",
    "message": "Restaurant is preparing your order"
  }
}
```

### Driver Location Updates
```json
{
  "event": "driver_location_update",
  "data": {
    "orderId": "order_123",
    "location": {
      "latitude": 40.7300,
      "longitude": -73.9950
    },
    "estimatedArrival": "2025-09-21T11:25:00Z"
  }
}
```

---

## Status Codes

- **200**: Success
- **201**: Created
- **400**: Bad Request
- **401**: Unauthorized
- **403**: Forbidden
- **404**: Not Found
- **422**: Validation Error
- **429**: Rate Limited
- **500**: Internal Server Error

## Rate Limiting

- General API: 1000 requests per hour per user
- Search API: 100 requests per minute per user
- Order creation: 10 requests per minute per user

## Error Codes

- `VALIDATION_ERROR`: Request validation failed
- `AUTHENTICATION_REQUIRED`: Authentication token required
- `INVALID_TOKEN`: Invalid or expired token
- `INSUFFICIENT_PERMISSIONS`: User lacks required permissions
- `RESOURCE_NOT_FOUND`: Requested resource not found
- `RESTAURANT_CLOSED`: Restaurant is currently closed
- `MINIMUM_ORDER_NOT_MET`: Order doesn't meet minimum requirement
- `PAYMENT_FAILED`: Payment processing failed
- `ORDER_ALREADY_CANCELLED`: Order cannot be cancelled
    ````

