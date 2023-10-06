#include <linux/module.h>
#define INCLUDE_VERMAGIC
#include <linux/build-salt.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

BUILD_SALT;

MODULE_INFO(vermagic, VERMAGIC_STRING);
MODULE_INFO(name, KBUILD_MODNAME);

__visible struct module __this_module
__section(".gnu.linkonce.this_module") = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

#ifdef CONFIG_RETPOLINE
MODULE_INFO(retpoline, "Y");
#endif

static const struct modversion_info ____versions[]
__used __section("__versions") = {
	{ 0x73708991, "module_layout" },
	{ 0xe558e54c, "wake_up_process" },
	{ 0x85602f54, "kthread_create_on_node" },
	{ 0xc5850110, "printk" },
	{ 0xcebf3e81, "kernel_clone" },
	{ 0x9f49dcc4, "__stack_chk_fail" },
	{ 0xa998009e, "put_pid" },
	{ 0xf37409c9, "do_wait" },
	{ 0x26f4e62d, "find_get_pid" },
	{ 0x952664c5, "do_exit" },
	{ 0x2d15d1b6, "do_execve" },
	{ 0x85416d23, "getname_kernel" },
};

MODULE_INFO(depends, "");

