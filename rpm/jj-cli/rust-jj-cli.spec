# Generated by rust2rpm 27
# * Doesn't compile for testutils
%bcond check 0

# prevent library files from being installed
%global cargo_install_lib 0

%global crate jj-cli

Name:           rust-jj-cli
Version:        0.31.0
Release:        %autorelease
Summary:        Jujutsu - an experimental version control system

License:        Apache-2.0
URL:            https://crates.io/crates/jj-cli
Source:         %{crates_source}
Source:         jj-cli-0.31.0-vendor.tar.xz

BuildRequires:  cargo-rpm-macros >= 26
BuildRequires:  pkgconfig(openssl)
BuildRequires:  pkgconfig(libgit2)

%global _description %{expand:
Jujutsu - an experimental version control system.}

%description %{_description}

%package     -n %{crate}
Summary:        %{summary}
# FIXME: paste output of %%cargo_license_summary here
License:        # FIXME
# LICENSE.dependencies contains a full license breakdown

%description -n %{crate} %{_description}

%files       -n %{crate}
%license LICENSE
%license docs/images/LICENSE
%license LICENSE.dependencies
%license cargo-vendor.txt
%{_bindir}/fake-diff-editor
%{_bindir}/fake-editor
%{_bindir}/fake-formatter
%{_bindir}/jj
%{bash_completions_dir}/jj.bash
%{fish_completions_dir}/jj.fish
%{zsh_completions_dir}/_jj

%prep
%autosetup -n %{crate}-%{version} -p1 -a1
%cargo_prep -v vendor
find ./vendor -type f -executable -name '*.rs' -exec chmod -x '{}' \;


%build
%cargo_build -f test-fakes
%{cargo_license_summary -f test-fakes}
%{cargo_license -f test-fakes} > LICENSE.dependencies
%{cargo_vendor_manifest}

%install
%cargo_install -f test-fakes
COMPLETE=bash "%{buildroot}%{_bindir}/jj" > jj.bash
COMPLETE=fish "%{buildroot}%{_bindir}/jj" > jj.fish
COMPLETE=zsh "%{buildroot}%{_bindir}/jj" > _jj
sed -i -e 's|%{buildroot}||g' jj.bash jj.fish _jj
install -Dpm 0644 jj.bash -t %{buildroot}%{bash_completions_dir}
install -Dpm 0644 jj.fish -t %{buildroot}%{fish_completions_dir}
install -Dpm 0644 _jj -t %{buildroot}%{zsh_completions_dir}


%if %{with check}
%check
%cargo_test -f test-fakes
%endif

%changelog
%autochangelog
