// Copyright © Tavian Barnes <tavianator@tavianator.com>
// SPDX-License-Identifier: 0BSD

/**
 * Signal hooks.
 */

#ifndef BFS_SIGHOOK_H
#define BFS_SIGHOOK_H

#include <signal.h>

/**
 * A dynamic signal hook.
 */
struct sighook;

/**
 * Signal hook flags.
 */
enum sigflags {
	/** Suppress the default action for this signal. */
	SH_CONTINUE = 1 << 0,
};

/**
 * A signal hook callback.  Hooks are executed from a signal handler, so must
 * only call async-signal-safe functions.
 *
 * @param sig
 *         The signal number.
 * @param info
 *         Additional information about the signal.
 * @param arg
 *         An arbitrary pointer passed to the hook.
 */
typedef void sighook_fn(int sig, siginfo_t *info, void *arg);

/**
 * Install a hook for a signal.
 *
 * @param sig
 *         The signal to hook.
 * @param fn
 *         The function to call.
 * @param arg
 *         An argument passed to the function.
 * @param flags
 *         Flags for the new hook.
 * @return
 *         The installed hook, or NULL on failure.
 */
struct sighook *sighook(int sig, sighook_fn *fn, void *arg, enum sigflags flags);

/**
 * On a best-effort basis, invoke the given hook just before the program is
 * abnormally terminated by a signal.
 *
 * @param fn
 *         The function to call.
 * @param arg
 *         An argument passed to the function.
 * @return
 *         The installed hook, or NULL on failure.
 */
struct sighook *atsigexit(sighook_fn *fn, void *arg);

/**
 * Remove a signal hook.
 */
void sigunhook(struct sighook *hook);

#endif // BFS_SIGHOOK_H
