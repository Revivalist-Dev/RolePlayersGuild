<%@ Page Title="RPG: Character Search" Language="C#" MasterPageFile="~/templates/1-Col.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Character.Search.Default" %>

<%@ Register Src="~/templates/controls/CharacterListing.ascx" TagPrefix="uc1" TagName="CharacterListing" %>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <meta name="description" content="RPG attracts all kinds of Role-Players. Using our robust search feature, you can easily find the right writing partners for you. From those who enjoy light-hearted, slice-of-life comedy themes to those who love to write about the dark and gritty R-rated themes." />
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="FullCol" runat="server">
    <fieldset runat="server" id="CharactListing" class="clearfix">
        <legend>
            <asp:Literal ID="litListingType" runat="server"></asp:Literal>
        </legend>
        <div class="col-sm-2 SearchSidebar">
            <asp:Button ID="btnUniverseFilter" runat="server" Text="Search By Universe" CssClass="btn btn-primary SideBarButton" OnClick="btnUniverseFilter_Click" />
            <div class="SideBar">
                <div id="FilterByGenre" class="SearchFiltering FancyCheckList">
                    <a class="FilterLabel btn btn-primary collapsed" data-toggle="collapse" href="#GenresPanel" aria-expanded="false" aria-controls="GenresPanel">Filter By Genre</a>
                    <div id="GenresPanel" class="collapse">
                        <asp:CheckBoxList ID="cblGenres" runat="server" RepeatLayout="UnorderedList" CssClass="FancyCheck" DataSourceID="sdsGenres" DataTextField="GenreName" DataValueField="GenreID" OnDataBound="cblGenres_DataBound" OnSelectedIndexChanged="btnSearch_Click" AutoPostBack="true"></asp:CheckBoxList>
                    </div>
                    <asp:SqlDataSource ID="sdsGenres" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT * FROM [Genres] ORDER BY [GenreName]"></asp:SqlDataSource>
                </div>
            </div>
            <div runat="server" id="divSidebarAd">
                <script async src="//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
                <!-- SearchSideBar -->
                <ins class="adsbygoogle"
                    style="display: block"
                    data-ad-client="ca-pub-1247828126747788"
                    data-ad-slot="4860476114"
                    data-ad-format="auto"></ins>
                <script>
                    (adsbygoogle = window.adsbygoogle || []).push({});
                </script>
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="cblGenres" EventName="SelectedIndexChanged" />
            </Triggers>
            <ContentTemplate>
                <div class="col-sm-10">
                    <asp:Panel runat="server" ID="pnlSearchBar" CssClass="ControlPanel form-inline clearfix SearchTools" Visible="false" DefaultButton="btnSearch">
                        <div class="ControlRow clearfix">
                            <div class="form-group col-sm-2">
                                <label>Name/ID</label>
                            </div>
                            <div class="form-group col-sm-6">
                                <asp:TextBox ID="txtLikeField" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group col-sm-2">
                                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                            </div>
                        </div>
                        <div class="ControlRow clearfix">
                            <div class="form-group col-sm-2">
                                <label>Basic Info</label>
                            </div>
                            <div class="form-group col-sm-3">
                                <label class="sr-only" for="ddlGender">Gender</label>
                                <asp:DropDownList ID="ddlGender" ClientIDMode="Static" CssClass="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="All Genders"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Males"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Females"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Hermaphrodites"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Genderless"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-sm-3">
                                <label class="sr-only" for="ddlOrientation">Sexuality</label>
                                <asp:DropDownList ID="ddlOrientation" ClientIDMode="Static" CssClass="form-control" runat="server" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="Any Sexuality"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Heterosexual"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Homosexual"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Bisexual"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Pansexual"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Asexual"></asp:ListItem>
                                    <asp:ListItem Value="7" Text="Demisexual"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="ControlRow clearfix">
                            <div class="form-group col-sm-2">
                                <label>Content</label>
                            </div>
                            <div class="form-group col-sm-3">
                                <label class="sr-only" for="ddlERP">ERP Preferences</label>
                                <asp:DropDownList ID="ddlERP" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="No Erotica Preferences"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Erotica Avoided"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Erotica Accepted"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Erotica Preferred"></asp:ListItem>
                                </asp:DropDownList>

                            </div>
                        </div>
                        <div class="ControlRow clearfix">
                            <div class="form-group col-sm-2">
                                <label>Writing</label>
                            </div>
                            <div class="form-group col-sm-3">
                                <label class="sr-only" for="ddlPostLength">Post Length</label>
                                <asp:DropDownList ID="ddlPostLength" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="Any Post Length"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="One-Line Capable"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Semi-Para Capable"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="Para Capable"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Multi-Para Capable"></asp:ListItem>
                                    <asp:ListItem Value="5" Text="Novella Capable"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-sm-3">
                                <label class="sr-only" for="ddlLiteracy">Literacy</label>
                                <asp:DropDownList ID="ddlLiteracy" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="Any Literacy Level"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Low Literacy"></asp:ListItem>
                                    <asp:ListItem Value="2" Text="Average Literacy"></asp:ListItem>
                                    <asp:ListItem Value="3" Text="High Literacy"></asp:ListItem>
                                    <asp:ListItem Value="4" Text="Extreme Literacy"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="ControlRow clearfix">
                            <div class="form-group col-sm-2">
                                <label for="ddlSortOrders">Other</label>
                            </div>
                            <div class="form-group col-sm-3">
                                <asp:DropDownList ID="ddlSource" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="Any Source"></asp:ListItem>
                                    <asp:ListItem Text="Fan-Fic" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Non-Canon" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="Original" Value="1"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-sm-3">
                                <asp:DropDownList ID="ddlContactPref" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="Any Contact Preferences"></asp:ListItem>
                                    <asp:ListItem Text="Okay with Discussions or Starters" Value="4"></asp:ListItem>
                                    <asp:ListItem Text="Spontaneous Starters Preferred" Value="3"></asp:ListItem>
                                    <asp:ListItem Text="Initial Discussion Preferred" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Not Looking For Role-Plays" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="form-group col-sm-3 FancyCheck">
                                <asp:CheckBox ID="chkShowOnlyOnline" runat="server" Text="Online Only" AutoPostBack="true" OnCheckedChanged="btnSearch_Click" />
                            </div>
                        </div>
                        <div class="ControlRow clearfix">
                            <div class="form-group col-sm-2">
                                <label for="ddlSortOrders">Order By</label>
                            </div>
                            <div class="form-group col-sm-3">
                                <asp:DropDownList ID="ddlSortOrders" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="btnSearch_Click">
                                    <asp:ListItem Value="0" Text="Newest Characters"></asp:ListItem>
                                    <asp:ListItem Value="1" Text="Oldest Characters"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="ControlRow clearfix sr-only">
                            <div class="col-sm-2">
                            </div>
                            <div class="col-sm-2">
                            </div>
                        </div>
                    </asp:Panel>
                    <div class="CharacterListing clearfix">
                        <asp:Repeater ID="rptCharacters" runat="server" OnItemDataBound="rptCharacters_ItemDataBound">
                            <ItemTemplate>
                                <asp:Panel runat="server" ID="pnlCharacter" ClientIDMode="Predictable" CssClass="col-xs-4 col-sm-2 col-xl-1 Character" itemscope itemtype="http://schema.org/CreativeWork">
                                    <div itemprop="character" itemscope itemtype="http://schema.org/Person">
                                        <a href="/Character/?id=<%# Eval("CharacterID") %>" class="<%# Eval("CharacterNameClass") %>" title="<%# Eval("CharacterDisplayName") %>" itemprop="sameAs">
                                            <label itemprop="name"><%# Eval("CharacterDisplayName") %></label>
                                        </a>

                                        <a title="<%# Eval("CharacterDisplayName") %>" href="/Character/?id=<%# Eval("CharacterID") %>" class="thumbnail" style="background-image: url(<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>);"></a>

                                        <%# OnlineStatus(Eval("LastAction"), Eval("ShowWhenOnline")) %>
                                    </div>
                                </asp:Panel>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <nav class="PagingControls" runat="server" id="navPagingControls" visible="false">
                        <ul class="pagination">
                            <li class="previous">
                                <asp:LinkButton ID="lbFirst" runat="server"
                                    OnClick="lbFirst_Click" aria-label="First"><span aria-hidden="true">&laquo;</span></asp:LinkButton>
                            </li>
                            <asp:Repeater ID="rptPaging" runat="server"
                                OnItemCommand="rptPaging_ItemCommand"
                                OnItemDataBound="rptPaging_ItemDataBound">
                                <ItemTemplate>
                                    <li>
                                        <asp:LinkButton ID="lbPaging" runat="server"
                                            CommandArgument='<%# Eval("PageIndex") %>'
                                            CommandName="newPage"
                                            Text='<%# Eval("PageText") %>'>
                                        </asp:LinkButton>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>

                            <li class="next">
                                <asp:LinkButton ID="lbLast" runat="server" aria-label="Last"
                                    OnClick="lbLast_Click"><span aria-hidden="true">&raquo;</span></asp:LinkButton>
                            </li>
                        </ul>
                    </nav>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </fieldset>

</asp:Content>
