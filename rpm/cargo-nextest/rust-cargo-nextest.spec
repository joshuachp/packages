# Generated by rust2rpm 27
# * Doesn't compile for testutils
%bcond check 0

# prevent library files from being installed
%global cargo_install_lib 0

%global crate cargo-nextest

Name:           rust-cargo-nextest
Version:        0.9.101
Release:        %autorelease
Summary:        Next-generation test runner for Rust

License:        Apache-2.0 OR MIT
URL:            https://crates.io/crates/cargo-nextest
Source:         %{crates_source}
Source:         cargo-nextest-0.9.101-vendor.tar.xz

BuildRequires:  cargo-rpm-macros >= 26

%global _description %{expand:
A next-generation test runner for Rust.}

%description %{_description}

%package     -n %{crate}
Summary:        %{summary}
# FIXME: paste output of %%cargo_license_summary here
License:        # FIXME
# LICENSE.dependencies contains a full license breakdown

%description -n %{crate} %{_description}

%files       -n %{crate}
%license LICENSE-APACHE
%license LICENSE-MIT
%license LICENSE.dependencies
%license cargo-vendor.txt
%doc CHANGELOG.md
%doc README.md
%{_bindir}/cargo-nextest

%prep
%autosetup -n %{crate}-%{version} -p1 -a1
%cargo_prep -v vendor
find ./vendor -type f -executable -name '*.rs' -exec chmod -x '{}' \;


%build
%cargo_build -n -f default-no-update
%{cargo_license_summary -n -f default-no-update}
%{cargo_license -n -f default-no-update} > LICENSE.dependencies
%{cargo_vendor_manifest}

%install
%cargo_install -n -f default-no-update


%if %{with check}
%check
%cargo_test -n -f default-no-update
%endif

%changelog
%autochangelog
