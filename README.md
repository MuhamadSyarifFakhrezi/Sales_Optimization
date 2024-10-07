# Sales Optimization
## Business Understanding
The store was opened in 2009 and is located in Poland. The store area is 120m2. Offers general food and basic chemical, hygienic articles. Has fresh bread from 4 different bakers, sweets, local vegetables, dairy, basic meat (ham, sausages), newspaper, home chemistry, etc.

The main problems faced by the owners are:
- Overhaul of the owners - the store employs 4 employees, but the owners' great involvement in the current operation of the store means that they are unable to assess the situation and take actions to adapt the business profile to market changes
- Strong exposure of current assets in relation to profits, necessary improvement of cash flow - the store brings lower and lower profits, there are problems with the availability of funds for current operations
- There is a significant amount of poorly rotating goods in the assortment of the store; there is also a group of goods generating significant losses. Shall the owners change the profile of shop or limit some of the products groups?
- The problem becomes goods with a short shelf life, which too often have to be overestimated due to the end of the shelf-life date

## Data Source
The collected dataset come from the multi-branch store computer system. The data shows stocking, sales, sales statistics, characteristics of products sold from January 2018 - December 2018. We use the 'sell_1' table to analyze the 2018 sales history. Table ‘sell_1’ is sales data from January 2018 to December 2018 contained of 16 columns and 23180 rows.

Here is data source link: [Data Source](https://www.kaggle.com/datasets/agatii/total-sale-2018-yearly-data-of-grocery-shop?select=SELL_1.csv)
Or can be downloaded here: [Dataset](https://github.com/MuhamadSyarifFakhrezi/Sales_Optimization/blob/main/TOTAL%20SALE%202018%20Yearly%20data%20of%20grocery%20shop..zip)

## Tools
MySQL (Data Wrangling), Tableau (Data Visualization)

## Data Wrangling
- Change the date separator from "," (comma) to "-" (hyphen) and change the decimal separator from "," (comma) to "." (dot) so that calculation operations can be performed.
- Changes the date format from date-month-year to year-month-date.
- Customize data type.
- Delete the outliers.
- Filter out the profitable names and product categories, as well as the names and products that generate losses.
  
The above data processing steps are only an overview, please refer to the following article for details: [Article](https://medium.com/@ms.fakhrezi/data-analysis-sales-optimization-f094853243bb)

## Visualization
The visualization was created using Tableau and included multiple metrics such as sales, profit, revenue, profitable and loss-making products.

Interactive dashboard link: [Dashboard](https://public.tableau.com/views/GrocerySales_16882239863740/SalesOptimation?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![Screenshot (967)](https://github.com/user-attachments/assets/69e36860-dcd3-4435-8aaf-7b614f23aadd)

## Summary
The summary here answers the business questions that have been asked.
- From the data obtained from the 'top category by sales' bar chart, the most sales were in the BREAD category, but the BREAD category was not included in the top 3 based on profit. Using this insight, you can increase the stock of bread, which is in high demand by customers, but as it is a perishable product, you still need to consider the right stock levels to maximise sales. Or maybe the shop owners can increase a little margin for the BREAD category to increase their sales profit, just a little increase in margin for products in the BREAD category will have a significant impact because monthly sales are very stable.  
- The top 3 months that generate the most profit are the summer which will enter the fall in July, August and September. Several product categories that increased significantly included ICE_CREAM_FROZEN, DRINK_JUICE, and BEER. However, when the season began to change to a season with cold weather, the ICE_CREAM_FROZEN and DRINK_JUICE product categories experienced a drastic decline. Therefore, create a store profile that maximizes the products that sell well in the winter months to maximize revenue which starts to wane as summer ends, the BREAD and DAIRY_CHESSE categories are the most sought-after staples in winter.
- We have collected several products that have margins above the average but the net value of purchase/cost is below average, we have also collected products that generate losses. From this insight, it can be used to rearrange the store profile so that it can be maximized.
- After completing a thorough survey of the data in the 'rotation_of_products' table, many data items were found to be missing, especially the most important features: rotations in days and rotations in time. Therefore, for the problem of commodity rotation, I don't know how to analyze it at the moment, and more data may be needed.
- Store owners can utilize the dashboard to monitor store condition without being directly involved in operations, insight from the dashboard can make it easier for store owners to adjust inventory or marketing strategies.
