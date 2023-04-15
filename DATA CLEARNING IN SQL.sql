/* 
Cleaning Data in Sql Queries
*/

Select *
from PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------

--Standardize Data Format
Select  SalesDateconverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
set  SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SalesDateconverted Date;

Update NashvilleHousing
set  SalesDateconverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------
--Populate Property Address Data
Select * 
from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.parcelID
	and a.[uniqueID ] <> b.[uniqueID ]
	Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.parcelID
	and a.[uniqueID ] <> b.[uniqueID ]

	-------------------------------------------------
--Breaking out Address into individual coloums (Address, Citi, State)

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX (',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySpiltAddress nvarchar(255);

Update NashvilleHousing
set  PropertySpiltAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX (',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add Propertyspiltcity nvarchar(255);

Update NashvilleHousing
set  Propertyspiltcity = SUBSTRING(PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) 

SELECT *
from PortfolioProject.dbo.NashvilleHousing

SELECT OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress, ',','.'),3),
PARSENAME(Replace(OwnerAddress, ',','.'),2),
PARSENAME(Replace(OwnerAddress, ',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add ownerSpiltAddress nvarchar(255);

Update NashvilleHousing
set  ownerSpiltAddress = PARSENAME(Replace(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
Add ownerspiltcity nvarchar(255);

Update NashvilleHousing
set  ownerspiltcity = PARSENAME(Replace(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
Add ownerSpiltstate nvarchar(255);

Update NashvilleHousing
set  ownerSpiltstate = PARSENAME(Replace(OwnerAddress, ',','.'),1)

select *
from PortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------------------------------------------
----changing Y and N to Yes and NO In Sold as Vacant
select distinct (SoldasVacant), Count(SoldasVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldasVacant
order by 2

Select SoldasVacant
, CASE when SoldasVacant = 'Y' THEN 'Yes'
		when SoldasVacant = 'N'THEN 'NO'
		ELSE SoldasVacant
		END
from PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SoldasVacant = CASE when SoldasVacant = 'Y' THEN 'Yes'
		when SoldasVacant = 'N'THEN 'NO'
		ELSE SoldasVacant
		END

-----------------------------
--REMOVE DUPLICATES
WITH RowNumCTE AS (
Select *,
ROW_NUMBER ()over(
PARTITION BY parcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
	ORDER BY 
	 UniqueID
	 )row_num

	from PortfolioProject.dbo.NashvilleHousing
	--Order by ParcelID
)
SELECT *
from RowNumCTE 
where row_num >1
Order by PropertyAddress

--DELECT UNUSED COLUMNS 

Select *
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN Fullbath, Halfbath, SaleDate
