--Cleaning Data in SQL
select *
from PortfolioProject.dbo.NashvilleHousing



select SaleDateConverted, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
Set SaleDate =CONVERT(Date,SaleDate)

Alter Table nashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
Set SaleDateConverted =CONVERT(Date,SaleDate)

--Property Address Data

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a 
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a 
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual Columns (address, City, State)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing 
--where a.PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing 

Alter Table nashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update NashvilleHousing 
Set PropertySplitAddress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

Alter Table nashvilleHousing
Add PropertySplitCity Nvarchar(255);

update NashvilleHousing
Set PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select*
from PortfolioProject.dbo.NashvilleHousing 

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing 

select
PARSENAME(Replace(OwnerAddress, ',', '.'),3), 
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

Alter Table nashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing 
Set OwnerSplitAddress =PARSENAME(Replace(OwnerAddress, ',', '.'),3) 

Alter Table nashvilleHousing
Add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
Set OwnerSplitCity =PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table nashvilleHousing
Add OwnerSplitState Nvarchar(255);

update NashvilleHousing
Set OwnerSplitState =PARSENAME(Replace(OwnerAddress,',','.'),1)

select *
from PortfolioProject.dbo.NashvilleHousing

--Change Y and N in "Sold as Vacant" field
select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant,
case when soldasvacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
--Remove Duplicates
with RowNumCTE as(
select *,
ROW_NUMBER() over (partition by parcelID,
propertyAddress, SalePrice, SaleDate, LegalReference
order by uniqueID)
row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
from RowNumCTE
where row_num>1
order by PropertyAddress
--select *
--from PortfolioProject.dbo.NashvilleHousing

--Delete Unused Columns
select *
from PortfolioProject.dbo.NashvilleHousing

alter Table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate























