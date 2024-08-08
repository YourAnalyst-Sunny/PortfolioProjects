select *
from PortfolioProject..NashvilleDataCleaning

--Standarized Date Format
select SaleDate, convert(date,SaleDate)
from PortfolioProject..NashvilleDataCleaning

update NashvilleDataCleaning
set Saledate= convert(date,SaleDate)

alter table NashvilleDataCleaning
add SaleDateConverted date;

update NashvilleDataCleaning
set SaleDateConverted= convert(date,SaleDate)

select SaleDateConverted
from NashvilleDataCleaning

--Populate Property address 
select *
from NashvilleDataCleaning
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleDataCleaning a
join NashvilleDataCleaning b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleDataCleaning a
join NashvilleDataCleaning b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking Our Address (to sepertate Address,City,State)
select PropertyAddress
from NashvilleDataCleaning

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress)) as Address
from NashvilleDataCleaning

alter table NashvilleDataCleaning
add PropertySplitAddress nvarchar(255);

update NashvilleDataCleaning
set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

alter table NashvilleDataCleaning
add PropertySplitCity nvarchar(255);

update NashvilleDataCleaning
set PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, len(PropertyAddress))

--Alternatiive method
select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleDataCleaning

alter table NashvilleDataCleaning
add OwnerSplitAddress nvarchar(255);

update NashvilleDataCleaning
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table NashvilleDataCleaning
add OwnerSplitCity nvarchar(255);

update NashvilleDataCleaning
set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table NashvilleDataCleaning
add OwnerSplitState nvarchar(255);

update NashvilleDataCleaning
set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)



--Change Y and L as 'Yes' and 'No' in SoldAsVacant

select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleDataCleaning
group by SoldAsVacant

select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end
from NashvilleDataCleaning

update NashvilleDataCleaning
set SoldAsVacant=
	case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end
from NashvilleDataCleaning

--Remove Duplicates


with RowNumCTE as(
select *,
	Row_Number() over(
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
				UniqueID)
				Row_num
from NashvilleDataCleaning)

delete
from RowNumCTE
where Row_num>1
--order by PropertyAddress

--Delete Unused Column:
alter table NashvilleDataCleaning
drop column PropertyAddress,OwnerAddress,TaxDistrict

alter table NashvilleDataCleaning
drop column SaleDate