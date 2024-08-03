                                 -------------DATA CLEANING USING SQL in SQL SERVER---------------------

---------We have taken a dataset of the Nashville Housing Community and we are trying to clean the data by handling the 
---------missing or inconsistent data. We are also trying to correct/ modify the unformatted and unclear data from the dataset.

select SaleDateConverted, CONVERT(Date,SaleDate) as UpdatedDate
from SQLPortfolioProject.dbo.[Nashville Housing]

Update [Nashville Housing] set
SaleDate = CONVERT(Date,SaleDate)--This update did not work even though it said rows were affected . hence using alter

ALTER TABLE [Nashville Housing]
Add SaleDateConverted Date;

Update [Nashville Housing] set
SaleDateConverted = CONVERT(Date, SaleDate)

--Populate property address data

select PropertyAddress
from SQLPortfolioProject.dbo.[Nashville Housing]
where PropertyAddress is null;

--Now we find that for same PARCEL ID's, we have address as null 
--for one of those entries. hence we are trying to update address now

select a.PropertyAddress, a.ParcelID, b.PropertyAddress,b.ParcelID, ISNULL(a.PropertyAddress, b.PropertyAddress) as updated from 
[Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL; -- NOW LETS isnull to check if address is getting affected

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from 
[Nashville Housing] a
join [Nashville Housing] b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL; --now it has got updated

--Breaking out Address into individual columns(Address, City,State)

select PropertyAddress from
SQLPortfolioProject.dbo.[Nashville Housing]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
from SQLPortfolioProject.dbo.[Nashville Housing]

ALTER TABLE SQLPortfolioProject.dbo.[Nashville Housing]
Add PropertySplitAddress nvarchar(255);

Update SQLPortfolioProject.dbo.[Nashville Housing] 
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE SQLPortfolioProject.dbo.[Nashville Housing]
Add PropertySplitCity nvarchar(255);

Update SQLPortfolioProject.dbo.[Nashville Housing] 
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select *
from SQLPortfolioProject.dbo.[Nashville Housing]

--Theres also another way to do the parse

select OwnerAddress from 
SQLPortfolioProject.dbo.[Nashville Housing]

Select PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
from SQLPortfolioProject.dbo.[Nashville Housing]

ALTER TABLE SQLPortfolioProject.dbo.[Nashville Housing]
Add OwnerSplitAddress nvarchar(255);

Update SQLPortfolioProject.dbo.[Nashville Housing] 
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE SQLPortfolioProject.dbo.[Nashville Housing]
Add OwnerSplitState nvarchar(255);

Update SQLPortfolioProject.dbo.[Nashville Housing] 
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE SQLPortfolioProject.dbo.[Nashville Housing]
Add OwnerSplitCity nvarchar(255);

Update SQLPortfolioProject.dbo.[Nashville Housing] 
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

--CHange Y and N to Yes and NO at the 'Solid as vacant' field

select distinct(SoldAsVacant), count(SoldAsVacant)
from SQLPortfolioProject.dbo.[Nashville Housing]
group by SoldAsVacant
order by 2


select distinct(SoldAsVacant),
CASE WHEN SoldAsVacant = 'Y' then 'Yes'
WHEN SoldAsVacant = 'N' then 'No'
ELSE SoldAsVacant
END
from SQLPortfolioProject.dbo.[Nashville Housing]

update SQLPortfolioProject.dbo.[Nashville Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
WHEN SoldAsVacant = 'N' then 'No'
ELSE SoldAsVacant
END
from SQLPortfolioProject.dbo.[Nashville Housing]

--remove duplicates
with rownumCTE as
(
SELECT *,
ROW_NUMBER()over(partition by
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY
UniqueID) as rownum
from SQLPortfolioProject.dbo.[Nashville Housing]
)
DELETE FROM rownumCTE
where rownum > 1
--order by PropertyAddress

Select *
From SQLPortfolioProject.dbo.[Nashville Housing]


ALTER TABLE SQLPortfolioProject.dbo.[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE SQLPortfolioProject.dbo.[Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

