# .SPEC-file to package RPMs for openSUSE

%define project_base_url https://gitlab.com/DavidGriffith
%define completions_dir %{_sysconfdir}/bash_completion.d

# build like this:
# rpmdev-spectool -f -g -R rpm/minipro-opensuse.spec
# rpmbuild -ba rpm/minipro-opensuse.spec

Summary: Program for controlling the MiniPRO TL866xx series of chip programmers
Name: minipro
%global commit %(git ls-remote -q %{project_base_url}/%{name}.git HEAD | awk '{print $1}')
%global shortcommit %(c=%{commit}; echo ${c:0:7})
%global commitdate %(curl -sq  "https://gitlab.com/api/v4/projects/6570223/repository/commits" | jq -c '.[] | select (.id == "%{commit}") .created_at' | awk '{gsub(/-/, ""); gsub (/"/, ""); print substr($0, 1, 8)}')
Version: %(git ls-remote -q --tags --refs %{project_base_url}/%{name}.git | awk -F/ '{ver=$NF} END{print ver}')^%{commitdate}g%{shortcommit}%{?dist}
Release: 1
License: GPLv3
URL: %{project_base_url}/%{name}
Source: %{project_base_url}/%{name}/-/archive/master/%{name}-master.tar.gz
BuildRequires: libusb-1_0-devel

%description
Software for Minipro TL866XX series of programmers from autoelectric.cn
Used to program flash, EEPROM, etc.

%prep
%autosetup -n %{name}-master

%build
make %{?_smp_mflags} PREFIX=%{_prefix}

%install
make install DESTDIR=%{buildroot} PREFIX=%{_prefix}

install -D -p -m 0644 udev/60-minipro.rules %{buildroot}/%{_udevrulesdir}/60-minipro.rules
install -D -p -m 0644 udev/61-minipro-plugdev.rules %{buildroot}/%{_udevrulesdir}/61-minipro-plugdev.rules
install -D -p -m 0644 udev/61-minipro-uaccess.rules %{buildroot}/%{_udevrulesdir}/61-minipro-uaccess.rules
install -D -p -m 0644 bash_completion.d/minipro %{buildroot}/%{completions_dir}/minipro

%files
%{!?_licensedir:%global license %%doc}
%license LICENSE
%doc README.md
%{_bindir}/minipro
%{_mandir}/man1/%{name}.*
%{_udevrulesdir}/*
%{_datadir}/minipro/infoic.xml
%{_datadir}/minipro/logicic.xml
%{completions_dir}/*
