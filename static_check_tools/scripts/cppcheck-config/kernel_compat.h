#ifndef __CPPCHECK_KERNEL_COMPAT_H__
#define __CPPCHECK_KERNEL_COMPAT_H__

/* 1. 屏蔽内核真实头文件的展开，防止预处理器爆炸 */
#define _LINUX_MODULE_H
#define _LINUX_KERNEL_H
#define _LINUX_INIT_H
#define _LINUX_SLAB_H
#define _LINUX_TYPES_H

/* 2. 基础类型与宏定义 */
#define GFP_KERNEL 0
#define KERN_INFO ""

#define __init
#define __exit
#define MODULE_LICENSE(x)
#define module_init(x)
#define module_exit(x)

/* 3. 内核关键 API 打桩 (映射为标准 C 库函数，触发 Cppcheck 内置内存检查) */
void *kmalloc(unsigned long size, gfp_t flags);
void *kzalloc(unsigned long size, gfp_t flags);
void kfree(const void *objp);
int printk(const char *fmt, ...);
char *strcpy(char *dest, const char *src);

#endif /* __CPPCHECK_KERNEL_COMPAT_H__ */