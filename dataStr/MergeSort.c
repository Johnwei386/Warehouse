#include <stdio.h>
#include <stdlib.h>
#include "include/Status.h"

int min(int x, int y) 
{
	return x < y ? x : y;
}

void merge_sort(int arr[], int len) 
{
	int* a = arr;
	int* b = (int*) malloc(len * sizeof(int));
	int seg, start;
	for (seg = 1; seg < len; seg += seg) { //seg = 1,2,4,8...
		for (start = 0; start < len; start += (seg + seg)) { //start = 0, 2, 4, 6, 8...(seg = 1)
			int low = start, mid = min(start + seg, len), high = min(start + seg + seg, len);
			int k = low;
			int start1 = low, end1 = mid;
			int start2 = mid, end2 = high;
			while (start1 < end1 && start2 < end2)
				b[k++] = a[start1] < a[start2] ? a[start1++] : a[start2++];
			while (start1 < end1)
				b[k++] = a[start1++];
			while (start2 < end2)
				b[k++] = a[start2++];
		}

		int* temp = a;
		a = b;
		b = temp;
	}

	if (a != arr) {
		int i;
		for (i = 0; i < len; i++)
			b[i] = a[i];
		b = a;
	}

	free(b);
}

void merge_sort_recursive(int arr[], int reg[], int start, int end) 
{
	if (start >= end) return;
	int len = end - start, mid = (len >> 1) + start;
	int start1 = start, end1 = mid;
	int start2 = mid + 1, end2 = end;
	merge_sort_recursive(arr, reg, start1, end1);
	merge_sort_recursive(arr, reg, start2, end2);
	int k = start;
	while (start1 <= end1 && start2 <= end2)
		reg[k++] = arr[start1] < arr[start2] ? arr[start1++] : arr[start2++];
	while (start1 <= end1)
		reg[k++] = arr[start1++];
	while (start2 <= end2)
		reg[k++] = arr[start2++];
	for (k = start; k <= end; k++)
		arr[k] = reg[k];
}

Status main(void)
{
	int arr[] = {12, 25, 33, 58, 49, 61, 102, 90};
	int len = 8;
	int reg[len];
	merge_sort(arr, 8);
	merge_sort_recursive(arr, reg, 0, len - 1);
	for(int i = 0; i < 8; i++) printf("%d ", arr[i]);
	printf("\n");
	return OK;
}
