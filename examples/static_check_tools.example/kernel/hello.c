#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/slab.h>


static int __init hello_init(void)
{

    char *buf;

    buf = kmalloc(10, GFP_KERNEL);


    strcpy(buf, "hello kernel");


    printk(KERN_INFO "hello\n");


    return 0;
}


static void __exit hello_exit(void)
{

}


module_init(hello_init);
module_exit(hello_exit);


MODULE_LICENSE("GPL");