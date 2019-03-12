#include <Status.h>
#include <Ceshi.h>

Status main(void)
{
	char *a = "你好， 世界！";
	int t, b;
	t = 12;
	b = 13;
	int c = sum(t, b);
	testPrint(a);
	printSum(c);

	return OK;
}
