#!/usr/local/opt/python@3.9/bin/python3.9
# -*- coding: utf-8 -*-
""" stdlib module. """
__all__ = (
    'INTERACTIVE',
    'IPYTHON',

    'PathLib',
    'AnyPath',
    'HOMEBREW_CELLAR',
    'HOMEBREW_PREFIX',
    'HOMEBREW_REPOSITORY',
    'HOMEBREW_SHELLENV_PREFIX',
    'HOMEBREW_ETC',
    'HOMEBREW_COMPLETION_D',
    'HOMEBREW_PROFILE_D',
    'IPYTHON',
    'major_minor',
    'major_minor_str',
    'scripts_base',
    'scripts_venv',
    'stdlib_path',
    'stdlib_beta',
    'stdlib_dev',
    'stdlib_site',
    'stdlib_user',
    'stdlib_choices',
    'stdlib_sudo',
    'sudo_path',
    'VENV',

    'main',
    'which',
    'requirements',
    'scripts_paths',
    'sudo',
    'rich_expand_all',
    'rich_expand_no',

    'console',
    'cp',
)
import inspect
import os
import pathlib
import shutil
import subprocess
import sys
import sysconfig
import typing
# noinspection PyCompatibility
import __main__

import setuptools.command.install

PathLib = pathlib.Path
AnyPath = typing.Optional[typing.Union[str, os.PathLike, PathLib]]
HOMEBREW_CELLAR: AnyPath = ''
HOMEBREW_PREFIX: AnyPath = ''
HOMEBREW_REPOSITORY: AnyPath = ''
HOMEBREW_SHELLENV_PREFIX: AnyPath = ''
exec(subprocess.check_output('brew shellenv | awk -F "[ =;]" \'/export HOME/ {print $2 "=" "PathLib("$3")"}\'',
                             env={}, shell=True, text=True, stderr=subprocess.DEVNULL))
HOMEBREW_ETC = HOMEBREW_PREFIX / 'etc'
HOMEBREW_COMPLETION_D = HOMEBREW_ETC / 'bash_completion.d'
HOMEBREW_PROFILE_D = HOMEBREW_ETC / 'profile.d'
INTERACTIVE = not hasattr(__main__, '__file__')
IPYTHON = hasattr(__builtins__, '__IPYTHON__')
major_minor = (sys.version_info.major, sys.version_info.minor, )
major_minor_str = f'{sys.version_info.major}.{sys.version_info.minor}'
scripts_base: typing.Optional[PathLib] = None
scripts_venv: typing.Optional[PathLib] = None
stdlib_path = PathLib(sysconfig.get_path("stdlib"))
stdlib_beta = stdlib_path / 'beta-packages'
stdlib_dev = stdlib_path / 'dev-packages'
stdlib_site = stdlib_path / 'site-packages'
stdlib_user = stdlib_path / 'user-packages'
stdlib_choices = ('beta', 'dev', 'site', 'user', )
stdlib_sudo = ''
sudo_path = None
VENV = sys.prefix != sys.base_prefix

# set sys.path before trying to import dev packages.
sys.path.extend([str(stdlib_beta), str(stdlib_dev), str(stdlib_user)])


def main(argv: typing.Optional[list] = None) -> typing.Union[PathLib, list[str], subprocess.CompletedProcess]:
    """
    Examples:
        >>> # Add STDLIB_TEST=1 in run configuration.
        >>> import os, sysconfig
        >>> os.environ['STDLIB_TEST'] = '1'
        >>>
        >>> python = PathLib(sys.executable).resolve()
        >>> su = which('sudo')
        >>>
        >>> assert main([]) == stdlib_user
        >>> assert main(['--target', 'dev']) == stdlib_dev
        >>>
        >>> assert main(['--sudo', '--no-test']) == ''
        >>> assert main(['--sudo', '/usr/dir/file.txt', '--no-test']) == su
        >>> del os.environ['STDLIB_TEST']
        >>> assert main(['--sudo']) == ''
        >>> sudo_path
        >>> assert main(['--sudo', '/usr/dir/file.txt']) == su
        >>>
        >>> import stdlib
        >>> stdlib.stdlib_path = PathLib('/usr')
        >>> out = main(['--install', '--test', 'simplejson'])
        >>> assert sudo_path not in out
        >>> for i in (python, '-m', 'pip', f'--target="{stdlib_user}"', '-y', 'simplejson'):
        ...     assert i in out
        >>>
        >>> stdlib.stdlib_path = PathLib(sysconfig.get_path("stdlib"))
        >>> stdlib.stdlib_sudo = ''
        >>> assert sudo_path not in main(['--install', '--test', 'simplejson'])
        >>>
        >>> os.environ['STDLIB_TEST'] = '1'
        >>> out = requirements()
        >>> found = {}
        >>> for i in stdlib_choices:
        ...     f = ('requirements' + ('' if i == 'site' else f'_{i}') + '.txt')
        ...     req = stdlib_path / f
        ...     if not req.is_file() and os.environ.get('STDLIB_TEST'):
        ...         req = PathLib(__file__).parent / f
        ...     for j in out:
        ...         library = getattr(stdlib, f'stdlib_{i}')
        ...         t = f'--target="{library}"'
        ...         for k in (python, '-m', 'pip', t, '-y', '-r', str(req)):
        ...             if t in j:
        ...                 found[i] = True
        ...                 assert k in j
        >>> assert sum(list(found.values())) == len(stdlib_choices)

    Args:
        argv:

    Returns:
        Target stdlib dir, or sudo for path, or pip Install command output.
    """
    import argparse
    pip_add = ['--use-feature=in-tree-build', ]
    argv, stdout = (sys.argv[1:], True) if argv is None else (argv, False)
    parser = argparse.ArgumentParser(description="Stdlib path and install/upgrade utils.")
    try:
        import argcomplete
        argcomplete.autocomplete(parser)
    except ModuleNotFoundError:
        pass

    parser.add_argument('--install', default=False, action='store_true',
                        help='Install packages to stdlib path (default: "user-packages").')
    parser.add_argument('--upgrade', default=False, action='store_true',
                        help='Install and upgrade packages to stdlib path (default: "user-packages").')
    parser.add_argument('--requirements', default=False, action='store_true',
                        help='Install requirements files. Can be used in combination with "--upgrade".')
    parser.add_argument('--target', type=str, metavar='TARGET', default='user', choices=stdlib_choices,
                        help='Stdlib target packages directory name (default: "user" for "user-packages".')
    # const is the value if '--sudo' with no value
    parser.add_argument('--sudo', type=PathLib, const=os.getcwd(), nargs=argparse.OPTIONAL, action='store',
                        help='Sudo path if path is not own by user and sudo installed (default: cwd if --sudo).')
    parser.add_argument('packages', nargs=argparse.REMAINDER,
                        help='Packages or additional options/arguments to pip. '
                             '"." for cwd will be used if install/upgrade is provided and not packages. '
                             'Packages will be installed if install/upgrade are not provided')
    parser.add_argument('--test', default=False or bool(os.environ.get('STDLIB_TEST')), action='store_true',
                        help='Show command but do not run it.')
    """
    argparse.ZERO_OR_MORE: fails for any remainder with '-'
    # argparse.REMAINDER: fails if first remainder start with '-'.
    """
    args, remainder = parser.parse_known_args(argv)
    remainder.extend(args.packages)  # first fail options in case -r or '-'. If not '-' packages first.
    if args.sudo:
        rv = sudo(args.sudo)
        if stdout:
            print(rv)
            sys.exit()
        return rv
    if args.requirements:
        requirements(args.upgrade)

    if args.target not in stdlib_choices:
        parser.error(f'target must be one of {stdlib_choices}')

    target = globals().get(f'stdlib_{args.target}')
    if (remainder and (not any([args.install, args.upgrade]) or not args.upgrade)) or args.install:
        args.install = ['install']
        args.upgrade = []
    if args.upgrade:
        args.install = ['install']
        args.upgrade = ['--upgrade']
    if not any([args.install, args.upgrade, remainder]):
        if stdout:
            print(target)
            sys.exit()
        return target
    elif not remainder:
        remainder = ['.']
    if not args.install:
        args.install = []
    for item in ('install', '-y', '--upgrade', '.',):
        if item in remainder:
            remainder.remove(item)
    command = [*sudo(starred=True), PathLib(sys.executable).resolve(), '-m', 'pip', *args.install, *args.upgrade,
               *pip_add, f'--install-option="--install-scripts={scripts_paths()[0]}"',
               f'--target="{target}"', '-y', *remainder]
    if args.test:
        if stdout:
            print(command)
            print()
            sys.exit()
        return command
    return subprocess.run(command, check=True, capture_output=True)


def requirements(upgrade=None) -> list[typing.Union[list[str], subprocess.CompletedProcess]]:
    """
    Creates stdlib directories and installs requirements.

    Args:
        upgrade: --upgrade or None/False for --install (Default: None)

    Returns:
        None.
    """
    s, stat = sudo(), os.stat(stdlib_path)
    rv = []
    for choice in stdlib_choices:
        if not (path := globals().get(f'stdlib_{choice}')).is_dir():
            os.system(f'{s} mkdir {path}')
            os.system(f'echo "alias .stdlib_{choice}@{major_minor_str}=\'cd {path}\" | '
                      f'{s} tee {HOMEBREW_PROFILE_D}/stdlib 1>/dev/null')
            if s:
                os.system(f'{s} chown {stat.st_uid}:{stat.st_gid} "{path}"')
                os.system(f'{s} chown {stat.st_uid}:{stat.st_gid} "{HOMEBREW_PROFILE_D}"/stdlib')
        file = ('requirements' + ('' if choice == 'site' else f'_{choice}') + '.txt')
        path = stdlib_path / file
        if not path.is_file() and os.environ.get('STDLIB_TEST'):
            path = PathLib(__file__).parent / file
        if not path.is_file():
            RuntimeWarning(f'{path=}: No such file')
            continue
        rv.append(main(['--target', choice, upgrade or '--install', '-r', str(path)]))
    if not (dest := (HOMEBREW_COMPLETION_D / 'python-argcomplete')).is_file():
        import argcomplete
        subprocess.run([*sudo(HOMEBREW_COMPLETION_D, starred=True), 'cp',
                        PathLib(argcomplete.__file__).parent.resolve() / HOMEBREW_COMPLETION_D.name / dest.name, dest],
                       check=True, capture_output=True)
    return rv


def scripts_paths() -> tuple[PathLib, PathLib]:
    class PyPath(setuptools.command.install.install):
        """PyPath Class."""
        _sysconfig_paths_script = 'import sysconfig; print(sysconfig.get_paths())'
        dist = None

        def run(self):
            # does not call install.run() by design
            # noinspection PyUnresolvedReferences
            self.distribution.install_scripts = self.install_scripts

        @classmethod
        def _scripts_install(cls):
            cls.dist = setuptools.Distribution({'cmdclass': {'install': cls}})
            cls.dist.dry_run = True
            cls.dist.parse_config_files()
            command = cls.dist.get_command_obj('install')
            command.ensure_finalized()
            command.run()
            return cls.dist.install_scripts

        @classmethod
        def scripts_install(cls) -> tuple[PathLib, PathLib]:
            """
            Site/Base and Venv Install Scripts Paths.

            >>> scripts_paths()

            Returns:
                Tuple with Site/Base and Venv Install Scripts Paths..
            """
            global scripts_base
            global scripts_venv
            _path_install_script = f'\nimport setuptools\nimport setuptools.command.install\n' \
                                   f'{inspect.getsource(PyPath)}\n' \
                                   f'print(PyPath._scripts_install())'
            scripts_venv = PathLib(PyPath._scripts_install())
            scripts_base = subprocess.run([PathLib(sys.executable).resolve(), _path_install_script], check=True,
                                          text=True, capture_output=True).stdout.rstrip('\n') if VENV else scripts_venv
            return scripts_base, scripts_venv
    return PyPath.scripts_install()


def sudo(path: AnyPath = stdlib_path, starred=False) -> typing.Union[str, list]:
    """
    Returns sudo if path is not own by user and sudo command installed.

    Examples:
        >>> su = which('sudo')
        >>> assert sudo('/tmp') == ''
        >>> assert sudo('/usr/bin') == '/usr/bin/sudo'
        >>> assert sudo('/usr/bin/no_dir/no_file.text') == su
        >>> assert sudo('no_dir/no_file.text') == ''
        >>> assert sudo('/tmp', starred=True) == []
        >>> assert sudo('/usr/bin', starred=True) == [su]

    Args:
        path: path (default: stdlib_path)
        starred: return starred/list for cmd with no shell (default: False).

    Returns:
        `sudo` or ``, str or list.
    """
    global stdlib_sudo
    global sudo_path
    sudo_path = sudo_path if sudo_path else which('sudo')
    rv = stdlib_sudo = sudo_path
    if sudo_path:
        top = [PathLib('/'), PathLib('.')]
        p = PathLib(path)
        while p:
            if p.exists():
                rv = '' if os.access(p, os.W_OK) else sudo_path
                break
            else:
                if p in top:
                    break
                p = p.parent
        if PathLib(path) == stdlib_path:
            stdlib_sudo = rv
    return ([rv] if rv else []) if starred else rv


def rich_expand_all(): rich.pretty.install(console=console, expand_all=True)
def rich_expand_no(): rich.pretty.install(console=console)


def which(cmd):
    """
    Checks if cmd or path is executable or exported bash function.

    Examples:
        >>> assert which('/usr/local') is None
        >>> assert which('/usr/bin/sudo') == '/usr/bin/sudo'
        >>> assert which('subprocess_test') == 'subprocess_test'
        >>> assert which('let') == 'let'
        >>> assert which('source') == 'source'

    Args:
        cmd: command or path.

    Returns:
        Cmd path.
    """
    return shutil.which(cmd, mode=os.X_OK) or subprocess.run(f'command -v {cmd}', shell=True).stdout or ''


if not stdlib_user.exists():
    requirements()

if INTERACTIVE:
    import rich.console
    import rich.pretty
    if IPYTHON:
        exec('%rehashx')
    console = rich.console.Console(color_system='256')
    cp = console.print
    rich_expand_all()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        sys.exit(-1)
